import Cocoa
import FlutterMacOS
import os

private let logger = Logger(subsystem: "dev.synk", category: "ios_media_stream")

/// Plays an iOS device's system audio, received over CoreDevice.
///
/// `IosMirrorPlugin` captures the screen as a camera, which carries no sound.
/// This path asks the device itself to send its system audio as RTP — the only
/// way to get audio off an iPhone.
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
        instance.controller = IosMediaStreamController()
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
    private let sessionsLock = NSLock()
    private var audioSessions: [Int64: IosMediaStreamSession] = [:]
    private var nextAudioSessionId: Int64 = 1

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
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

      case "setAudioSessionVolume":
        guard let sessionId = Self.sessionId(from: call),
          let arguments = call.arguments as? [String: Any],
          let volume = (arguments["volume"] as? NSNumber)?.floatValue
        else {
          result(
            FlutterError(
              code: "invalid_args", message: "sessionId and volume are required", details: nil))
          return
        }
        sessionsLock.lock()
        let session = audioSessions[sessionId]
        sessionsLock.unlock()
        session?.setAudioVolume(volume)
        result(nil)

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    private func startAudio(deviceId: String, result: @escaping FlutterResult) {
      Task { [weak self] in
        guard let self else { return }

        let session = IosMediaStreamSession()
        let sessionId = storeAudioSession(session)

        do {
          try await session.start(deviceId: deviceId)
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
    /// suspension point.
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
  }

  /// One device's system-audio stream and the decoder and player behind it.
  @available(macOS 14.0, *)
  final class IosMediaStreamSession {
    private var stream: CoreDeviceMediaStream?
    private var audioReader: RtpSocketReader?
    private var audioReporter: RtcpReporter?
    private let audioDecoder = AacEldStreamDecoder()
    private let audioPlayer = SystemAudioPlayer()

    // MARK: - Lifecycle

    func start(deviceId: String) async throws {
      let stream = try await CoreDeviceMediaStream.connect(udid: deviceId)
      self.stream = stream

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
    }

    private static func makeReporter(
      for endpoint: MediaStreamEndpoint, clockRate: UInt32
    ) -> RtcpReporter? {
      guard endpoint.rtcpEnabled else { return nil }
      return RtcpReporter(
        socket: endpoint.socket, senderIP: endpoint.senderIP,
        rtcpPort: endpoint.rtcpRemotePort, interfaceName: endpoint.interfaceName,
        localSSRC: endpoint.localSSRC, remoteSSRC: endpoint.remoteSSRC,
        interval: endpoint.rtcpSendInterval, clockRate: clockRate)
    }

    func stop() async {
      // `RtpSocketReader.stop()` waits for its thread so the decoder can be
      // torn down without racing a packet. That wait must not sit on the
      // concurrency pool, hence the hop off it.
      audioReporter?.stop()
      audioReporter = nil

      let audio = audioReader
      audioReader = nil
      await withCheckedContinuation { continuation in
        DispatchQueue.global(qos: .userInitiated).async { [audioDecoder] in
          audio?.stop()
          audioDecoder.invalidate()
          continuation.resume()
        }
      }

      audioDecoder.onSamples = nil
      audioPlayer.stop()

      if let stream {
        _ = try? await stream.stopAll()
        stream.release()
        self.stream = nil
      }
    }

    // MARK: - Audio playback

    func setAudioMuted(_ muted: Bool) {
      audioPlayer.setMuted(muted)
    }

    func setAudioVolume(_ volume: Float) {
      audioPlayer.setVolume(volume)
    }
  }

#endif
