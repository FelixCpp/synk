import AVFoundation
import Cocoa
import CoreMedia
import FlutterMacOS
import os

private let logger = Logger(subsystem: "dev.synk", category: "ios_media_stream")

/// How long to wait for the first decoded frame before giving up on a stream.
private let firstFrameTimeout: TimeInterval = 8

/// Mirrors an iOS device over CoreDevice instead of a capture session.
///
/// Where `IosMirrorPlugin` captures the device as a camera — which needs USB
/// and carries no sound — this path asks the device itself to send its screen
/// and its system audio as RTP. That works over Wi-Fi as well as USB, and it is
/// the only way to get audio off an iPhone.
///
/// Both plugins answer the same method names, so the Dart side can try this one
/// first and fall back to the capture session.
public class IosMediaStreamPlugin: NSObject, FlutterPlugin {
  /// Typed as `Any?` because a stored property cannot carry an availability
  /// annotation; the controller it holds is arm64 and macOS 14 only.
  private var controller: Any?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "dev.synk/ios_media_stream",
      binaryMessenger: registrar.messenger
    )

    let instance = IosMediaStreamPlugin()
    #if arch(arm64)
      if isCoreDeviceMediaStreamAvailable, #available(macOS 14.0, *) {
        let controller = IosMediaStreamController(registry: registrar.textures)
        instance.controller = controller
        FlutterEventChannel(
          name: "dev.synk/ios_media_stream/screen_size",
          binaryMessenger: registrar.messenger
        ).setStreamHandler(controller.screenSizeStream)
      }
    #endif

    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    #if arch(arm64)
      if #available(macOS 14.0, *), let controller = controller as? IosMediaStreamController {
        controller.handle(call, result: result)
        return
      }
    #endif

    if call.method == "isAvailable" {
      result(false)
      return
    }

    logger.info(
      "No CoreDevice media stream: needs Xcode, Apple silicon and macOS 14 or newer")
    result(
      FlutterError(
        code: "unavailable", message: MediaStreamError.unavailable.localizedDescription,
        details: nil))
  }
}

#if arch(arm64)

  /// Owns the running sessions and answers the channel once CoreDevice is known
  /// to be usable.
  @available(macOS 14.0, *)
  final class IosMediaStreamController {
    let screenSizeStream = IosMediaStreamScreenSizeHandler()

    private let registry: FlutterTextureRegistry
    private let sessionsLock = NSLock()
    private var sessions: [Int64: IosMediaStreamSession] = [:]
    /// Audio-only sessions, keyed by an id of their own: they register no
    /// texture, so there is no texture id to key them by.
    private var audioSessions: [Int64: IosMediaStreamSession] = [:]
    private var nextAudioSessionId: Int64 = 1

    init(registry: FlutterTextureRegistry) {
      self.registry = registry
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
      case "isAvailable":
        result(true)

      case "startMirror":
        guard let arguments = call.arguments as? [String: Any],
          let deviceId = arguments["deviceId"] as? String
        else {
          result(FlutterError(code: "invalid_args", message: "deviceId is required", details: nil))
          return
        }
        startMirror(deviceId: deviceId, result: result)

      case "stopMirror":
        guard let textureId = Self.textureId(from: call) else {
          result(
            FlutterError(code: "invalid_args", message: "textureId is required", details: nil))
          return
        }
        Task { [weak self] in
          await self?.destroySession(textureId)
          result(nil)
        }

      case "captureScreenshot":
        guard let session = resolveSession(from: call, result: result) else { return }
        guard let png = session.captureScreenshot() else {
          result(
            FlutterError(
              code: "screenshot_failed", message: "No frame available yet.", details: nil))
          return
        }
        result(FlutterStandardTypedData(bytes: png))

      case "startRecording":
        guard let session = resolveSession(from: call, result: result) else { return }
        guard let arguments = call.arguments as? [String: Any],
          let path = arguments["path"] as? String
        else {
          result(FlutterError(code: "invalid_args", message: "path is required", details: nil))
          return
        }
        do {
          try session.startRecording(path: path)
          result(nil)
        } catch {
          result(
            FlutterError(
              code: "recording_failed", message: error.localizedDescription, details: nil))
        }

      case "stopRecording":
        guard let session = resolveSession(from: call, result: result) else { return }
        session.stopRecording { success in result(success) }

      case "setAudioMuted":
        guard let session = resolveSession(from: call, result: result) else { return }
        guard let arguments = call.arguments as? [String: Any],
          let muted = arguments["muted"] as? Bool
        else {
          result(FlutterError(code: "invalid_args", message: "muted is required", details: nil))
          return
        }
        session.setAudioMuted(muted)
        result(nil)

      case "startAudio":
        guard let arguments = call.arguments as? [String: Any],
          let deviceId = arguments["deviceId"] as? String
        else {
          result(FlutterError(code: "invalid_args", message: "deviceId is required", details: nil))
          return
        }
        startAudio(deviceId: deviceId, result: result)

      case "stopAudio":
        guard let sessionId = Self.sessionId(from: call) else {
          result(
            FlutterError(code: "invalid_args", message: "sessionId is required", details: nil))
          return
        }
        Task { [weak self] in
          await self?.destroyAudioSession(sessionId)
          result(nil)
        }

      case "setAudioSessionMuted":
        guard let sessionId = Self.sessionId(from: call),
          let arguments = call.arguments as? [String: Any],
          let muted = arguments["muted"] as? Bool
        else {
          result(
            FlutterError(
              code: "invalid_args", message: "sessionId and muted are required", details: nil))
          return
        }
        sessionsLock.lock()
        let session = audioSessions[sessionId]
        sessionsLock.unlock()
        session?.setAudioMuted(muted)
        result(nil)

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    private func startAudio(deviceId: String, result: @escaping FlutterResult) {
      Task { [weak self] in
        guard let self else { return }

        let session = IosMediaStreamSession(registry: registry)
        let sessionId = storeAudioSession(session)

        do {
          try await session.startAudioOnly(deviceId: deviceId)
          result(["sessionId": sessionId])
        } catch {
          await destroyAudioSession(sessionId)
          result(
            FlutterError(
              code: "audio_failed", message: error.localizedDescription, details: nil))
        }
      }
    }

    /// Takes the lock off the async path: `NSLock` may not be held across a
    /// suspension point, which is why the video path has `store` and `take`.
    private func storeAudioSession(_ session: IosMediaStreamSession) -> Int64 {
      sessionsLock.lock()
      defer { sessionsLock.unlock() }
      let sessionId = nextAudioSessionId
      nextAudioSessionId += 1
      audioSessions[sessionId] = session
      return sessionId
    }

    private func takeAudioSession(_ sessionId: Int64) -> IosMediaStreamSession? {
      sessionsLock.lock()
      defer { sessionsLock.unlock() }
      return audioSessions.removeValue(forKey: sessionId)
    }

    private func destroyAudioSession(_ sessionId: Int64) async {
      await takeAudioSession(sessionId)?.stop()
    }

    private static func sessionId(from call: FlutterMethodCall) -> Int64? {
      guard let arguments = call.arguments as? [String: Any] else { return nil }
      return (arguments["sessionId"] as? NSNumber)?.int64Value
    }

    private func startMirror(deviceId: String, result: @escaping FlutterResult) {
      Task { [weak self] in
        guard let self else { return }

        let session = IosMediaStreamSession(registry: registry)
        let textureId = registry.register(session)
        session.textureId = textureId
        session.onScreenSizeChanged = { [weak self] width, height in
          self?.screenSizeStream.send(textureId: textureId, width: width, height: height)
        }

        store(session, for: textureId)

        do {
          let size = try await session.start(deviceId: deviceId)
          result([
            "textureId": textureId,
            "width": size.width,
            "height": size.height,
            "hasAudio": session.hasAudio,
          ])
        } catch {
          await destroySession(textureId)
          result(
            FlutterError(code: "start_failed", message: error.localizedDescription, details: nil))
        }
      }
    }

    private static func textureId(from call: FlutterMethodCall) -> Int64? {
      guard let arguments = call.arguments as? [String: Any] else { return nil }
      return (arguments["textureId"] as? NSNumber)?.int64Value
    }

    private func resolveSession(from call: FlutterMethodCall, result: @escaping FlutterResult)
      -> IosMediaStreamSession?
    {
      guard let textureId = Self.textureId(from: call) else {
        result(FlutterError(code: "invalid_args", message: "textureId is required", details: nil))
        return nil
      }

      sessionsLock.lock()
      let session = sessions[textureId]
      sessionsLock.unlock()

      guard let session else {
        result(
          FlutterError(
            code: "unknown_texture", message: "No session for \(textureId)", details: nil))
        return nil
      }
      return session
    }

    private func store(_ session: IosMediaStreamSession, for textureId: Int64) {
      sessionsLock.lock()
      sessions[textureId] = session
      sessionsLock.unlock()
    }

    private func take(_ textureId: Int64) -> IosMediaStreamSession? {
      sessionsLock.lock()
      defer { sessionsLock.unlock() }
      return sessions.removeValue(forKey: textureId)
    }

    private func destroySession(_ textureId: Int64) async {
      let session = take(textureId)
      session?.onScreenSizeChanged = nil
      await session?.stop()
      registry.unregisterTexture(textureId)
    }
  }

  /// One mirrored device: the negotiated streams, the decoders behind them and
  /// everything hanging off the decoded frames.
  @available(macOS 14.0, *)
  final class IosMediaStreamSession: NSObject, FlutterTexture {
    private let registry: FlutterTextureRegistry
    var textureId: Int64 = -1
    var onScreenSizeChanged: ((Int, Int) -> Void)?
    private(set) var hasAudio = false

    private var stream: CoreDeviceMediaStream?
    private var videoReader: RtpSocketReader?
    private var audioReader: RtpSocketReader?
    private var videoReporter: RtcpReporter?
    private var audioReporter: RtcpReporter?
    private let videoDecoder = HevcStreamDecoder()
    private let audioDecoder = AacEldStreamDecoder()

    private let bufferLock = NSLock()
    private var latestPixelBuffer: CVPixelBuffer?
    private var width = 0
    private var height = 0
    private var firstFrame: CheckedContinuation<(width: Int, height: Int)?, Never>?

    // MARK: Recording

    private let recordingLock = NSLock()
    private var assetWriter: AVAssetWriter?
    private var assetWriterInput: AVAssetWriterInput?
    private var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    private var recordingStart: CMTime?

    // MARK: Audio playback

    private let audioPlayer = SystemAudioPlayer()

    init(registry: FlutterTextureRegistry) {
      self.registry = registry
      super.init()
    }

    // MARK: - Lifecycle

    func start(deviceId: String) async throws -> (width: Int, height: Int) {
      let stream = try await CoreDeviceMediaStream.connect(udid: deviceId)
      self.stream = stream

      let video = try await stream.start(.video)
      videoDecoder.onFrame = { [weak self] pixelBuffer, presentationTime in
        self?.handle(pixelBuffer: pixelBuffer, presentationTime: presentationTime)
      }
      let videoReporter = Self.makeReporter(
        for: video, clockRate: HevcStreamDecoder.clockRate)
      self.videoReporter = videoReporter
      videoDecoder.onPacketLoss = { videoReporter?.requestKeyframe() }
      let videoReader = RtpSocketReader(
        socket: video.socket, payloadType: video.payloadType,
        onRtp: { [weak self] packet in
          videoReporter?.noteRtp(packet)
          self?.videoDecoder.receive(packet)
        },
        onRtcp: { datagram in videoReporter?.noteRtcp(datagram) })
      self.videoReader = videoReader
      videoReader.start()
      videoReporter?.start()

      // Audio is a separate stream and a separate negotiation. A device that
      // will not hand over sound should still be mirrored, so this failure is
      // logged instead of raised.
      do {
        try await startAudio(on: stream)
      } catch {
        logger.info(
          """
          No system audio for \(deviceId, privacy: .public): \
          \(error.localizedDescription, privacy: .public)
          """
        )
      }

      // The negotiated size is only a hint — the real one comes from the
      // stream's own parameter sets, so wait for a decoded frame.
      guard let size = await awaitFirstFrame() else {
        throw NSError(
          domain: "IosMediaStreamPlugin", code: -3,
          userInfo: [
            NSLocalizedDescriptionKey:
              "The device accepted the stream but sent no decodable frame."
          ])
      }
      return size
    }

    /// Brings up only the system-audio stream.
    ///
    /// The screen comes from the AVFoundation capture session, which carries
    /// no sound; this is the one path that does. Nothing here touches the
    /// texture or the video decoder, so the session never registers one.
    func startAudioOnly(deviceId: String) async throws {
      let stream = try await CoreDeviceMediaStream.connect(udid: deviceId)
      self.stream = stream
      try await startAudio(on: stream)
    }

    /// Negotiates the audio stream and starts reading it. Shared by the
    /// mirroring path and the audio-only one so both report sound the same way.
    private func startAudio(on stream: CoreDeviceMediaStream) async throws {
      let audio = try await stream.start(.audio)
      audioDecoder.onSamples = { [weak self] samples in
        self?.audioPlayer.play(interleaved: samples)
      }
      let audioReporter = Self.makeReporter(
        for: audio, clockRate: UInt32(AacEldStreamDecoder.sampleRate))
      self.audioReporter = audioReporter
      let audioReader = RtpSocketReader(
        socket: audio.socket, payloadType: audio.payloadType,
        onRtp: { [weak self] packet in
          audioReporter?.noteRtp(packet)
          self?.audioDecoder.receive(packet)
        },
        onRtcp: { datagram in audioReporter?.noteRtcp(datagram) })
      self.audioReader = audioReader
      audioReader.start()
      audioReporter?.start()
      hasAudio = true
    }

    private static func makeReporter(
      for endpoint: MediaStreamEndpoint, clockRate: UInt32, requestsKeyframes: Bool = false
    ) -> RtcpReporter? {
      guard endpoint.rtcpEnabled else { return nil }
      return RtcpReporter(
        socket: endpoint.socket, senderIP: endpoint.senderIP,
        rtcpPort: endpoint.rtcpRemotePort, interfaceName: endpoint.interfaceName,
        localSSRC: endpoint.localSSRC, remoteSSRC: endpoint.remoteSSRC,
        interval: endpoint.rtcpSendInterval, clockRate: clockRate,
        requestsKeyframes: requestsKeyframes)
    }

    private func awaitFirstFrame() async -> (width: Int, height: Int)? {
      await withCheckedContinuation { continuation in
        registerFirstFrameWait(continuation)
      }
    }

    /// Either answers straight away, if a frame already arrived, or parks the
    /// continuation for `handle` to resume.
    private func registerFirstFrameWait(
      _ continuation: CheckedContinuation<(width: Int, height: Int)?, Never>
    ) {
      bufferLock.lock()
      if width > 0, height > 0 {
        let size = (width: width, height: height)
        bufferLock.unlock()
        continuation.resume(returning: size)
        return
      }
      firstFrame = continuation
      bufferLock.unlock()

      // A screen that never changes still sends its first frame, so silence
      // this long means the stream is not arriving at all.
      DispatchQueue.main.asyncAfter(deadline: .now() + firstFrameTimeout) { [weak self] in
        self?.resolveFirstFrame(with: nil)
      }
    }

    /// Resumes a pending first-frame wait exactly once.
    private func resolveFirstFrame(with size: (width: Int, height: Int)?) {
      bufferLock.lock()
      let continuation = firstFrame
      firstFrame = nil
      bufferLock.unlock()
      continuation?.resume(returning: size)
    }

    func stop() async {
      // `RtpSocketReader.stop()` waits for its thread so the decoders can be
      // torn down without racing a packet. That wait must not sit on the
      // concurrency pool, hence the hop off it.
      videoReporter?.stop()
      audioReporter?.stop()
      videoReporter = nil
      audioReporter = nil

      let video = videoReader
      let audio = audioReader
      videoReader = nil
      audioReader = nil
      await withCheckedContinuation { continuation in
        DispatchQueue.global(qos: .userInitiated).async { [videoDecoder, audioDecoder] in
          video?.stop()
          audio?.stop()
          videoDecoder.invalidate()
          audioDecoder.invalidate()
          continuation.resume()
        }
      }

      videoDecoder.onFrame = nil
      videoDecoder.onPacketLoss = nil
      audioDecoder.onSamples = nil

      // Nothing will arrive any more, so release anyone still waiting.
      resolveFirstFrame(with: nil)
      audioPlayer.stop()
      cancelRecording()
      releaseLatestFrame()

      if let stream {
        _ = try? await stream.stopAll()
        stream.release()
        self.stream = nil
      }
    }

    private func releaseLatestFrame() {
      bufferLock.lock()
      latestPixelBuffer = nil
      bufferLock.unlock()
    }

    // MARK: - Frames

    private func handle(pixelBuffer: CVPixelBuffer, presentationTime: CMTime) {
      let frameWidth = CVPixelBufferGetWidth(pixelBuffer)
      let frameHeight = CVPixelBufferGetHeight(pixelBuffer)

      bufferLock.lock()
      latestPixelBuffer = pixelBuffer
      let didResize = frameWidth != width || frameHeight != height
      width = frameWidth
      height = frameHeight
      let continuation = firstFrame
      firstFrame = nil
      bufferLock.unlock()

      // The first frame answers `start`; later size changes go to the stream.
      continuation?.resume(returning: (width: frameWidth, height: frameHeight))

      append(pixelBuffer: pixelBuffer, presentationTime: presentationTime)

      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        if didResize, continuation == nil {
          onScreenSizeChanged?(frameWidth, frameHeight)
        }
        registry.textureFrameAvailable(textureId)
      }
    }

    func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
      bufferLock.lock()
      defer { bufferLock.unlock() }
      guard let latestPixelBuffer else { return nil }
      return Unmanaged.passRetained(latestPixelBuffer)
    }

    func captureScreenshot() -> Data? {
      bufferLock.lock()
      let pixelBuffer = latestPixelBuffer
      bufferLock.unlock()
      guard let pixelBuffer else { return nil }

      let image = CIImage(cvPixelBuffer: pixelBuffer)
      guard let cgImage = CIContext().createCGImage(image, from: image.extent) else { return nil }
      return NSBitmapImageRep(cgImage: cgImage).representation(using: .png, properties: [:])
    }

    // MARK: - Recording

    func startRecording(path: String) throws {
      bufferLock.lock()
      let size = (width: width, height: height)
      bufferLock.unlock()
      guard size.width > 0, size.height > 0 else {
        throw NSError(
          domain: "IosMediaStreamPlugin", code: -1,
          userInfo: [NSLocalizedDescriptionKey: "No decoded frame yet."])
      }

      recordingLock.lock()
      defer { recordingLock.unlock() }
      guard assetWriter == nil else { return }

      let url = URL(fileURLWithPath: path)
      try? FileManager.default.removeItem(at: url)

      let writer = try AVAssetWriter(outputURL: url, fileType: .mp4)
      let input = AVAssetWriterInput(
        mediaType: .video,
        outputSettings: [
          AVVideoCodecKey: AVVideoCodecType.h264,
          AVVideoWidthKey: size.width,
          AVVideoHeightKey: size.height,
        ])
      input.expectsMediaDataInRealTime = true

      guard writer.canAdd(input) else {
        throw NSError(
          domain: "IosMediaStreamPlugin", code: -2,
          userInfo: [NSLocalizedDescriptionKey: "The recorder rejected the stream."])
      }
      writer.add(input)

      // The decoder hands over pixel buffers, so the adaptor does the wrapping
      // rather than us rebuilding sample buffers.
      let adaptor = AVAssetWriterInputPixelBufferAdaptor(
        assetWriterInput: input, sourcePixelBufferAttributes: nil)
      writer.startWriting()

      assetWriter = writer
      assetWriterInput = input
      pixelBufferAdaptor = adaptor
      recordingStart = nil
    }

    func stopRecording(completion: @escaping (Bool) -> Void) {
      recordingLock.lock()
      guard let writer = assetWriter else {
        recordingLock.unlock()
        completion(false)
        return
      }
      let input = assetWriterInput
      let started = recordingStart != nil
      assetWriter = nil
      assetWriterInput = nil
      pixelBufferAdaptor = nil
      recordingStart = nil
      recordingLock.unlock()

      // Without a started session the file would be unplayable, so throw it
      // away rather than hand over a broken recording.
      guard started else {
        writer.cancelWriting()
        completion(false)
        return
      }

      input?.markAsFinished()
      writer.finishWriting { completion(writer.status == .completed) }
    }

    private func cancelRecording() {
      recordingLock.lock()
      let writer = assetWriter
      let input = assetWriterInput
      assetWriter = nil
      assetWriterInput = nil
      pixelBufferAdaptor = nil
      recordingStart = nil
      recordingLock.unlock()

      input?.markAsFinished()
      writer?.cancelWriting()
    }

    private func append(pixelBuffer: CVPixelBuffer, presentationTime: CMTime) {
      recordingLock.lock()
      defer { recordingLock.unlock() }
      guard let writer = assetWriter, let adaptor = pixelBufferAdaptor else { return }

      if recordingStart == nil {
        writer.startSession(atSourceTime: presentationTime)
        recordingStart = presentationTime
      }
      guard adaptor.assetWriterInput.isReadyForMoreMediaData else { return }
      adaptor.append(pixelBuffer, withPresentationTime: presentationTime)
    }

    // MARK: - Audio playback

    func setAudioMuted(_ muted: Bool) {
      audioPlayer.setMuted(muted)
    }
  }

  final class IosMediaStreamScreenSizeHandler: NSObject, FlutterStreamHandler {
    private var sink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink)
      -> FlutterError?
    {
      sink = eventSink
      return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
      sink = nil
      return nil
    }

    func send(textureId: Int64, width: Int, height: Int) {
      DispatchQueue.main.async { [weak self] in
        self?.sink?(["textureId": textureId, "width": width, "height": height])
      }
    }
  }

#endif
