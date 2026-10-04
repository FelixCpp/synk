import AVFoundation
import Cocoa
import CoreMedia
import FlutterMacOS
import VideoToolbox

// MARK: - Format description helper

private func makeFormatDescription(sps: [UInt8], pps: [UInt8]) -> CMVideoFormatDescription? {
  var formatDescription: CMVideoFormatDescription?

  let status = sps.withUnsafeBufferPointer { spsBuffer -> OSStatus in
    pps.withUnsafeBufferPointer { ppsBuffer -> OSStatus in
      guard let spsBase = spsBuffer.baseAddress, let ppsBase = ppsBuffer.baseAddress else {
        return -1
      }

      let pointers: [UnsafePointer<UInt8>] = [spsBase, ppsBase]
      let sizes: [Int] = [spsBuffer.count, ppsBuffer.count]

      return pointers.withUnsafeBufferPointer { pointerBuffer -> OSStatus in
        sizes.withUnsafeBufferPointer { sizeBuffer -> OSStatus in
          CMVideoFormatDescriptionCreateFromH264ParameterSets(
            allocator: kCFAllocatorDefault,
            parameterSetCount: 2,
            parameterSetPointers: pointerBuffer.baseAddress!,
            parameterSetSizes: sizeBuffer.baseAddress!,
            nalUnitHeaderLength: 4,
            formatDescriptionOut: &formatDescription
          )
        }
      }
    }
  }

  return status == noErr ? formatDescription : nil
}

// MARK: - Per-device mirror session

/// One live mirror: its own FlutterTexture registration, VideoToolbox decode
/// session and Annex-B reassembly buffer. Each connected device gets its own
/// instance, so any number of devices can mirror concurrently - the plugin
/// no longer owns any single shared decode state itself.
private final class MirrorTextureSession: NSObject, FlutterTexture {
  let registry: FlutterTextureRegistry
  var textureId: Int64 = -1

  private var session: VTDecompressionSession?
  private var formatDescription: CMVideoFormatDescription?
  private var pendingSPS: Data?
  private var pendingPPS: Data?

  private let bufferLock = NSLock()
  private var latestPixelBuffer: CVPixelBuffer?

  private var pendingBuffer = Data()

  // MARK: Recording

  private var assetWriter: AVAssetWriter?
  private var assetWriterInput: AVAssetWriterInput?
  private var isRecordingArmed = false
  private var isRecording = false

  init(registry: FlutterTextureRegistry) {
    self.registry = registry
    super.init()
  }

  // MARK: FlutterTexture

  func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
    bufferLock.lock()
    defer { bufferLock.unlock() }
    guard let buffer = latestPixelBuffer else { return nil }
    return Unmanaged.passRetained(buffer)
  }

  // MARK: Lifecycle

  func invalidate() {
    if let session {
      VTDecompressionSessionInvalidate(session)
    }
    session = nil
    formatDescription = nil
    pendingSPS = nil
    pendingPPS = nil
    pendingBuffer.removeAll()

    bufferLock.lock()
    latestPixelBuffer = nil
    bufferLock.unlock()

    if isRecording || isRecordingArmed {
      assetWriterInput?.markAsFinished()
      assetWriter?.cancelWriting()
    }
    assetWriter = nil
    assetWriterInput = nil
    isRecordingArmed = false
    isRecording = false
  }

  // MARK: Recording

  /// Arms recording: the actual `AVAssetWriter` session only starts once the
  /// next IDR frame arrives, so the output file always begins on a keyframe
  /// and is decodable from byte zero.
  func startRecording(path: String) throws {
    guard !isRecording, !isRecordingArmed else { return }

    let url = URL(fileURLWithPath: path)
    try? FileManager.default.removeItem(at: url)

    let writer = try AVAssetWriter(outputURL: url, fileType: .mp4)
    let input = AVAssetWriterInput(
      mediaType: .video,
      outputSettings: nil,
      sourceFormatHint: formatDescription
    )
    input.expectsMediaDataInRealTime = true

    guard writer.canAdd(input) else {
      throw NSError(
        domain: "ScreenMirrorPlugin",
        code: -1,
        userInfo: [NSLocalizedDescriptionKey: "Recorder cannot accept the incoming H264 stream."]
      )
    }
    writer.add(input)
    writer.startWriting()

    assetWriter = writer
    assetWriterInput = input
    isRecordingArmed = true
  }

  func stopRecording(completion: @escaping (Bool) -> Void) {
    guard let writer = assetWriter, isRecording || isRecordingArmed else {
      completion(false)
      return
    }

    isRecording = false
    isRecordingArmed = false
    assetWriterInput?.markAsFinished()
    writer.finishWriting {
      completion(writer.status == .completed)
    }
    assetWriter = nil
    assetWriterInput = nil
  }

  private func appendToRecording(sampleBuffer: CMSampleBuffer, isKeyframe: Bool, presentationTime: CMTime) {
    guard isRecording || isRecordingArmed else { return }

    if isRecordingArmed {
      guard isKeyframe else { return }
      assetWriter?.startSession(atSourceTime: presentationTime)
      isRecordingArmed = false
      isRecording = true
    }

    guard isRecording, let input = assetWriterInput, input.isReadyForMoreMediaData else { return }
    input.append(sampleBuffer)
  }

  // MARK: Incremental Annex-B parsing

  func feedVideoChunk(_ chunk: Data) {
    pendingBuffer.append(chunk)
    extractCompleteNALUnits()
  }

  private func extractCompleteNALUnits() {
    let bytes = [UInt8](pendingBuffer)
    var startCodeIndices: [Int] = []

    var i = 0
    while i + 2 < bytes.count {
      if bytes[i] == 0x00, bytes[i + 1] == 0x00, bytes[i + 2] == 0x01 {
        startCodeIndices.append(i)
        i += 3
      } else {
        i += 1
      }
    }

    // Need at least two start codes: the first NAL unit's end is only known
    // once the *next* one starts. The last one found might still be
    // incomplete (more bytes for it may still be in flight).
    guard startCodeIndices.count >= 2 else { return }

    var consumedUpTo = 0
    for index in 0..<(startCodeIndices.count - 1) {
      let start = startCodeIndices[index] + 3
      var end = startCodeIndices[index + 1]
      while end > start, bytes[end - 1] == 0x00 {
        end -= 1
      }
      if end > start {
        let type = bytes[start] & 0x1F
        let payload = pendingBuffer.subdata(in: start..<end)
        handleNALUnit(type: type, payload: payload)
      }
      consumedUpTo = startCodeIndices[index + 1]
    }

    if consumedUpTo > 0 {
      pendingBuffer.removeSubrange(0..<consumedUpTo)
    }
  }

  private func handleNALUnit(type: UInt8, payload: Data) {
    switch type {
    case 7:
      pendingSPS = payload
      tryCreateSession()
    case 8:
      pendingPPS = payload
      tryCreateSession()
    case 1, 5:
      decode(nal: payload, isKeyframe: type == 5)
    default:
      break
    }
  }

  private func tryCreateSession() {
    guard session == nil, let sps = pendingSPS, let pps = pendingPPS else { return }
    guard let formatDescription = makeFormatDescription(sps: [UInt8](sps), pps: [UInt8](pps)) else {
      NSLog("MirrorTextureSession: failed to build format description")
      return
    }
    self.formatDescription = formatDescription
    createSession(formatDescription: formatDescription)
  }

  // MARK: VideoToolbox

  private func createSession(formatDescription: CMVideoFormatDescription) {
    var callbackRecord = VTDecompressionOutputCallbackRecord(
      decompressionOutputCallback: screenMirrorDecompressionCallback,
      decompressionOutputRefCon: Unmanaged.passUnretained(self).toOpaque()
    )

    let attributes: [String: Any] = [
      kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
    ]

    let status = VTDecompressionSessionCreate(
      allocator: kCFAllocatorDefault,
      formatDescription: formatDescription,
      decoderSpecification: nil,
      imageBufferAttributes: attributes as CFDictionary,
      outputCallback: &callbackRecord,
      decompressionSessionOut: &session
    )

    if status != noErr {
      NSLog("MirrorTextureSession: VTDecompressionSessionCreate failed: \(status)")
    }
  }

  private func decode(nal: Data, isKeyframe: Bool) {
    guard let session, let formatDescription else { return }

    var avcc = Data()
    var length = UInt32(nal.count).bigEndian
    withUnsafeBytes(of: &length) { avcc.append(contentsOf: $0) }
    avcc.append(nal)

    var blockBuffer: CMBlockBuffer?
    let blockStatus = CMBlockBufferCreateWithMemoryBlock(
      allocator: kCFAllocatorDefault,
      memoryBlock: nil,
      blockLength: avcc.count,
      blockAllocator: kCFAllocatorDefault,
      customBlockSource: nil,
      offsetToData: 0,
      dataLength: avcc.count,
      flags: 0,
      blockBufferOut: &blockBuffer
    )
    guard blockStatus == kCMBlockBufferNoErr, let blockBuffer else { return }

    let replaceStatus = avcc.withUnsafeBytes { rawBuffer -> OSStatus in
      CMBlockBufferReplaceDataBytes(
        with: rawBuffer.baseAddress!,
        blockBuffer: blockBuffer,
        offsetIntoDestination: 0,
        dataLength: avcc.count
      )
    }
    guard replaceStatus == kCMBlockBufferNoErr else { return }

    let presentationTime = CMClockGetTime(CMClockGetHostTimeClock())
    var timing = CMSampleTimingInfo(
      duration: .invalid,
      presentationTimeStamp: presentationTime,
      decodeTimeStamp: .invalid
    )

    var sampleBuffer: CMSampleBuffer?
    var sampleSize = avcc.count
    let sampleStatus = CMSampleBufferCreateReady(
      allocator: kCFAllocatorDefault,
      dataBuffer: blockBuffer,
      formatDescription: formatDescription,
      sampleCount: 1,
      sampleTimingEntryCount: 1,
      sampleTimingArray: &timing,
      sampleSizeEntryCount: 1,
      sampleSizeArray: &sampleSize,
      sampleBufferOut: &sampleBuffer
    )
    guard sampleStatus == noErr, let sampleBuffer else { return }

    appendToRecording(sampleBuffer: sampleBuffer, isKeyframe: isKeyframe, presentationTime: presentationTime)

    var infoFlags = VTDecodeInfoFlags()
    let decodeStatus = VTDecompressionSessionDecodeFrame(
      session,
      sampleBuffer: sampleBuffer,
      flags: [],
      frameRefcon: nil,
      infoFlagsOut: &infoFlags
    )
    if decodeStatus != noErr {
      NSLog("MirrorTextureSession: decode failed: \(decodeStatus)")
    }
  }

  fileprivate func handleDecodedFrame(_ pixelBuffer: CVPixelBuffer) {
    bufferLock.lock()
    latestPixelBuffer = pixelBuffer
    bufferLock.unlock()

    // The VideoToolbox callback fires on an internal decoder thread.
    // textureFrameAvailable must be nudged from the main/platform thread on
    // macOS or later updates silently stop propagating to the engine.
    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      self.registry.textureFrameAvailable(self.textureId)
    }
  }
}

private func screenMirrorDecompressionCallback(
  decompressionOutputRefCon: UnsafeMutableRawPointer?,
  sourceFrameRefCon: UnsafeMutableRawPointer?,
  status: OSStatus,
  infoFlags: VTDecodeInfoFlags,
  imageBuffer: CVImageBuffer?,
  presentationTimeStamp: CMTime,
  presentationDuration: CMTime
) {
  guard status == noErr, let imageBuffer, let refCon = decompressionOutputRefCon else {
    if status != noErr {
      NSLog("MirrorTextureSession: decompression callback error status=\(status)")
    }
    return
  }
  let session = Unmanaged<MirrorTextureSession>.fromOpaque(refCon).takeUnretainedValue()
  session.handleDecodedFrame(imageBuffer)
}

// MARK: - Plugin

/// Registers `MirrorTextureSession`s on demand and routes method calls and
/// incoming video chunks to the right one by texture id. Each session is a
/// fully independent FlutterTexture + decoder, so arbitrarily many devices
/// can mirror at once - the plugin itself is just a session directory.
public class ScreenMirrorPlugin: NSObject, FlutterPlugin {
  private let registry: FlutterTextureRegistry

  private let sessionsLock = NSLock()
  private var sessions: [Int64: MirrorTextureSession] = [:]

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "dev.synk/screen_mirror",
      binaryMessenger: registrar.messenger
    )
    let instance = ScreenMirrorPlugin(registry: registrar.textures)
    registrar.addMethodCallDelegate(instance, channel: channel)

    // Raw binary channel for video chunks - avoids per-chunk method-call/
    // standard-codec overhead at video bitrate/frequency. Each message is
    // prefixed with an 8-byte big-endian texture id so it can be routed to
    // the right session without a per-session channel.
    registrar.messenger.setMessageHandlerOnChannel(
      "dev.synk/screen_mirror/video_chunk"
    ) { data, reply in
      if let data {
        instance.feedVideoChunk(data)
      }
      reply(nil)
    }
  }

  init(registry: FlutterTextureRegistry) {
    self.registry = registry
    super.init()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "createTexture":
      let session = MirrorTextureSession(registry: registry)
      let textureId = registry.register(session)
      session.textureId = textureId

      sessionsLock.lock()
      sessions[textureId] = session
      sessionsLock.unlock()

      result(textureId)
    case "destroyTexture":
      guard let textureId = textureId(from: call) else {
        result(FlutterError(code: "invalid_args", message: "textureId is required", details: nil))
        return
      }
      destroySession(textureId)
      result(nil)
    case "startRecording":
      guard let textureId = textureId(from: call), let session = session(for: textureId) else {
        result(FlutterError(code: "invalid_args", message: "textureId is required", details: nil))
        return
      }
      guard let args = call.arguments as? [String: Any], let path = args["path"] as? String else {
        result(FlutterError(code: "invalid_args", message: "path is required", details: nil))
        return
      }
      do {
        try session.startRecording(path: path)
        result(nil)
      } catch {
        result(FlutterError(code: "recording_failed", message: error.localizedDescription, details: nil))
      }
    case "stopRecording":
      guard let textureId = textureId(from: call), let session = session(for: textureId) else {
        result(FlutterError(code: "invalid_args", message: "textureId is required", details: nil))
        return
      }
      session.stopRecording { success in
        result(success)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func textureId(from call: FlutterMethodCall) -> Int64? {
    guard let args = call.arguments as? [String: Any] else { return nil }
    return (args["textureId"] as? NSNumber)?.int64Value
  }

  private func session(for textureId: Int64) -> MirrorTextureSession? {
    sessionsLock.lock()
    defer { sessionsLock.unlock() }
    return sessions[textureId]
  }

  private func destroySession(_ textureId: Int64) {
    sessionsLock.lock()
    let session = sessions.removeValue(forKey: textureId)
    sessionsLock.unlock()

    session?.invalidate()
    registry.unregisterTexture(textureId)
  }

  private func feedVideoChunk(_ data: Data) {
    guard data.count > 8 else { return }

    var textureId: Int64 = 0
    for offset in 0..<8 {
      textureId = (textureId << 8) | Int64(data[data.startIndex + offset])
    }

    let payload = data.subdata(in: (data.startIndex + 8)..<data.endIndex)
    session(for: textureId)?.feedVideoChunk(payload)
  }
}
