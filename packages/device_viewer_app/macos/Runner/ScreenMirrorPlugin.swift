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

// MARK: - Plugin

/// Registers a FlutterTexture and feeds it frames decoded from a live,
/// arbitrarily-chunked Annex-B byte stream pushed from Dart (the real
/// per-device video socket opened via ConnectedAdbDevice.startScreenMirror()).
///
/// Unlike a fixture file, TCP chunks don't align with NAL unit boundaries -
/// a NAL can be split across two chunks, or one chunk can contain several -
/// so incoming bytes are appended to a running buffer and only *complete*
/// NAL units (bounded by two start codes) are extracted and decoded; any
/// trailing partial unit is left in the buffer for the next chunk.
public class ScreenMirrorPlugin: NSObject, FlutterPlugin, FlutterTexture {
  private let registry: FlutterTextureRegistry
  private var textureId: Int64 = -1

  private var session: VTDecompressionSession?
  private var formatDescription: CMVideoFormatDescription?
  private var pendingSPS: Data?
  private var pendingPPS: Data?

  private let bufferLock = NSLock()
  private var latestPixelBuffer: CVPixelBuffer?

  private var pendingBuffer = Data()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "dev.deviceviewer/screen_mirror",
      binaryMessenger: registrar.messenger
    )
    let instance = ScreenMirrorPlugin(registry: registrar.textures)
    registrar.addMethodCallDelegate(instance, channel: channel)

    // Raw binary channel for video chunks - avoids per-chunk method-call/
    // standard-codec overhead at video bitrate/frequency.
    registrar.messenger.setMessageHandlerOnChannel(
      "dev.deviceviewer/screen_mirror/video_chunk"
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
      textureId = registry.register(self)
      result(textureId)
    case "start":
      reset()
      result(nil)
    case "stop":
      reset()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: FlutterTexture

  public func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
    bufferLock.lock()
    defer { bufferLock.unlock() }
    guard let buffer = latestPixelBuffer else { return nil }
    return Unmanaged.passRetained(buffer)
  }

  // MARK: Stream state

  private func reset() {
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
  }

  // MARK: Incremental Annex-B parsing

  private func feedVideoChunk(_ chunk: Data) {
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
      decode(nal: payload)
    default:
      break
    }
  }

  private func tryCreateSession() {
    guard session == nil, let sps = pendingSPS, let pps = pendingPPS else { return }
    guard let formatDescription = makeFormatDescription(sps: [UInt8](sps), pps: [UInt8](pps)) else {
      NSLog("ScreenMirrorPlugin: failed to build format description")
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
      NSLog("ScreenMirrorPlugin: VTDecompressionSessionCreate failed: \(status)")
    }
  }

  private func decode(nal: Data) {
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

    var sampleBuffer: CMSampleBuffer?
    var sampleSize = avcc.count
    let sampleStatus = CMSampleBufferCreateReady(
      allocator: kCFAllocatorDefault,
      dataBuffer: blockBuffer,
      formatDescription: formatDescription,
      sampleCount: 1,
      sampleTimingEntryCount: 0,
      sampleTimingArray: nil,
      sampleSizeEntryCount: 1,
      sampleSizeArray: &sampleSize,
      sampleBufferOut: &sampleBuffer
    )
    guard sampleStatus == noErr, let sampleBuffer else { return }

    var infoFlags = VTDecodeInfoFlags()
    let decodeStatus = VTDecompressionSessionDecodeFrame(
      session,
      sampleBuffer: sampleBuffer,
      flags: [],
      frameRefcon: nil,
      infoFlagsOut: &infoFlags
    )
    if decodeStatus != noErr {
      NSLog("ScreenMirrorPlugin: decode failed: \(decodeStatus)")
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
      NSLog("ScreenMirrorPlugin: decompression callback error status=\(status)")
    }
    return
  }
  let plugin = Unmanaged<ScreenMirrorPlugin>.fromOpaque(refCon).takeUnretainedValue()
  plugin.handleDecodedFrame(imageBuffer)
}
