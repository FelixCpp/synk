import Foundation
import os

#if arch(arm64)
  import AVConferenceStubs
  import CoreDevice
  import CoreDeviceProtocols
#endif

private let logger = Logger(subsystem: "dev.synk", category: "ios_media_stream")

private let coreDeviceBinaryPath =
  "/Library/Developer/PrivateFrameworks/CoreDevice.framework/Versions/A/CoreDevice"
private let avConferenceBinaryPath =
  "/System/Library/PrivateFrameworks/AVConference.framework/Versions/A/AVConference"

/// Whether a CoreDevice media stream can be attempted at all. AVConference is
/// in the dyld shared cache, so only its bundle is on disk to check.
let isCoreDeviceMediaStreamAvailable: Bool = {
  #if arch(arm64)
    guard #available(macOS 14.0, *) else { return false }
    let fileManager = FileManager.default
    return fileManager.fileExists(atPath: coreDeviceBinaryPath)
      && fileManager.fileExists(atPath: (avConferenceBinaryPath as NSString).deletingLastPathComponent)
  #else
    return false
  #endif
}()

/// How long the device should keep a stream alive.
///
/// This is a hard deadline, not an idle timeout: the device stops sending when
/// it expires, whatever is going on. Mirroring has no natural end, so the
/// value is generous rather than tuned.
let defaultStreamTimeout: UInt = 24 * 60 * 60

/// What kind of stream to ask the device for.
enum MediaStreamKind {
  case video
  case audio
}

/// Where a started stream will arrive, and in what shape.
struct MediaStreamEndpoint {
  /// The host end of the CoreDevice tunnel; the socket is already bound here.
  let socket: Int32
  let payloadType: UInt8
  /// Where the device sends from, and where its RTCP wants to be answered.
  let senderIP: String
  let senderPort: UInt16
  let rtcpRemotePort: UInt16
  let localSSRC: UInt32
  let remoteSSRC: UInt32
  let rtcpEnabled: Bool
  let rtcpSendInterval: Double
  /// The utun the CoreDevice tunnel runs on; the RTCP destination is scoped
  /// to it, like the receive socket.
  let interfaceName: String
  /// How long the device promises to keep the stream alive, in seconds.
  let timeout: UInt
  /// The ceiling the device agreed to, in bits per second.
  let maxBitrate: UInt
  /// Encoder details that change how the stream has to be handled.
  let usesLongTermReference: Bool
  let tilesPerFrame: UInt
  let keyFrameInterval: UInt
  let codecFeatures: String
  /// Zero for audio streams.
  let width: Int
  let height: Int
  let frameRate: Int
  let source: String
}

enum MediaStreamError: LocalizedError {
  case unavailable
  case deviceNotFound(String, known: [String])
  case notSupportedByDevice(String)
  case noTunnel(String)
  case noFreePort
  case negotiationFailed(String)
  case encryptedStream

  var errorDescription: String? {
    switch self {
    case .unavailable:
      return "CoreDevice or AVConference is not installed on this Mac."
    case let .deviceNotFound(udid, known):
      return "CoreDevice does not know \(udid). Known devices: \(known.joined(separator: ", "))"
    case let .notSupportedByDevice(what):
      return "This device does not offer \(what)."
    case let .noTunnel(udid):
      return "No CoreDevice tunnel address for \(udid)."
    case .noFreePort:
      return "No free local port pair for the stream."
    case let .negotiationFailed(reason):
      return "The device rejected the media stream: \(reason)"
    case .encryptedStream:
      return "The device negotiated an encrypted stream, which synk cannot read."
    }
  }
}

#if arch(arm64)

  /// Negotiates CoreDevice media streams for one device and keeps them alive.
  ///
  /// CoreDevice brokers the handshake but carries no media: the offer and
  /// answer are opaque AVConference blobs, and once they have been exchanged
  /// the device sends plain RTP to an address we name. So this type does the
  /// handshake and hands back a bound socket; reading the RTP is
  /// `MediaStreamRtp`'s job.
  @available(macOS 14.0, *)
  final class CoreDeviceMediaStream {
    private let udid: String
    private let device: RemoteDevice
    private let assertion: DeviceUsageAssertion

    /// Held for the lifetime of the session: without a usage assertion the
    /// device stays paired but unconnected, and every capability disappears.
    private init(udid: String, device: RemoteDevice, assertion: DeviceUsageAssertion) {
      self.udid = udid
      self.device = device
      self.assertion = assertion
    }

    static func connect(udid: String) async throws -> CoreDeviceMediaStream {
      guard isCoreDeviceMediaStreamAvailable else { throw MediaStreamError.unavailable }

      let manager = await sharedManager().value
      let wanted = canonicalUDID(udid)
      let device = manager.devices.values.first { candidate in
        guard let identifier = candidate.deviceInfo.udid else { return false }
        return canonicalUDID(identifier) == wanted
      }

      guard let device else {
        let known = manager.devices.values.compactMap { $0.deviceInfo.udid }
        throw MediaStreamError.deviceNotFound(udid, known: known)
      }

      let assertion = try await device.acquireDeviceUsageAssertion(
        withReason: "synk mirrors this device",
        options: UsageAssertionOptions(requiredPreparedness: DevicePreparedness(rawValue: 0))
      )

      return CoreDeviceMediaStream(udid: udid, device: device, assertion: assertion)
    }

    /// Which of the two streams this device is willing to send. Throws rather
    /// than returning an empty set when the query itself fails: "the device
    /// said no" and "we could not ask" need different handling.
    func supportedKinds() async throws -> Set<String> {
      let info: DeviceMediaStream.SupportInfoResponse
      do {
        info = try await device.mediaStreamSupportInfo
      } catch {
        throw MediaStreamError.negotiationFailed(
          "cannot read the media stream support info: \((error as NSError).localizedDescription)")
      }
      // `common` is the intersection of what the device and this Mac support.
      let common = MediaStreamSupportedFeatures(rawValue: info.common.supportedFeatures)
      var kinds: Set<String> = []
      if common.rawValue & MediaStreamSupportedFeatures.primaryDisplayMirroredOutput.rawValue != 0 {
        kinds.insert("video")
      }
      if common.rawValue & MediaStreamSupportedFeatures.systemAudioOutput.rawValue != 0 {
        kinds.insert("audio")
      }
      return kinds
    }

    func start(_ kind: MediaStreamKind, timeout: UInt = defaultStreamTimeout) async throws
      -> MediaStreamEndpoint
    {
      let supported = try await supportedKinds()
      switch kind {
      case .video where !supported.contains("video"):
        throw MediaStreamError.notSupportedByDevice("screen mirroring over CoreDevice")
      case .audio where !supported.contains("audio"):
        throw MediaStreamError.notSupportedByDevice("system audio output")
      default:
        break
      }

      guard let peer = device.deviceInfo.tunnelIPAddressString,
        let host = Self.hostTunnelAddress(peer: peer)
      else { throw MediaStreamError.noTunnel(udid) }

      // Bind before asking the device, not after: the receiver port has to be
      // named in the start request, and anything bound-then-closed could be
      // taken by another process in between.
      guard
        let receiver = Self.bindReceiver(ip: host.ip, interfaceName: host.interface)
      else { throw MediaStreamError.noFreePort }
      var handedOver = false
      defer { if !handedOver { close(receiver.socket) } }

      // The offer has to exist before the device is asked, and the receiver
      // address has to be named in the same request — the device refuses a
      // start request without one.
      let negotiation = try Self.makeNegotiator(kind: kind, deviceInfo: device.deviceInfo)
      let response: DeviceMediaStream.StartResponse
      do {
        response = try await device.startMediaStream(
          with: DeviceMediaStream.StartRequest(
            timeout: timeout,
            type: kind == .video ? .video : .audio,
            direction: .output,
            negotiatorOffer: negotiation.offer,
            clientSupportedFeatures: MediaStreamSupportedFeatures.current.rawValue,
            receiverIP: host.ip,
            receiverPort: receiver.port,
            options: negotiation.startOptions
          ))
      } catch {
        throw MediaStreamError.negotiationFailed(
          (error as NSError).localizedDescription)
      }

      try Self.finishNegotiation(negotiation.negotiator, answer: response.negotiatorAnswer)

      let connection = response.connection
      let config = connection.streamConfig
      guard config.SRTPCipherSuite == 0, config.SRTCPCipherSuite == 0 else {
        _ = try? await stopAll()
        throw MediaStreamError.encryptedStream
      }

      logger.info(
        """
        Media stream for \(self.udid, privacy: .public): \
        \(connection.source?.description ?? "?", privacy: .public) from \
        [\(connection.sender.ipv6Address, privacy: .public)]:\(connection.sender.port) \
        payload \(config.TxPayloadType)
        """
      )

      handedOver = true
      return MediaStreamEndpoint(
        socket: receiver.socket,
        payloadType: UInt8(truncatingIfNeeded: config.TxPayloadType),
        senderIP: connection.sender.ipv6Address,
        senderPort: connection.sender.port,
        rtcpRemotePort: config.RTCPRemotePort,
        localSSRC: config.LocalSSRC,
        remoteSSRC: config.RemoteSSRC,
        rtcpEnabled: config.RTCPEnabled,
        rtcpSendInterval: config.RTCPSendInterval,
        interfaceName: host.interface,
        timeout: connection.timeout,
        maxBitrate: config.RXMaxBitrate,
        usesLongTermReference: config.IsltrpEnabled,
        tilesPerFrame: config.TilesPerFrame,
        keyFrameInterval: config.KeyFrameInterval,
        codecFeatures: config.TxCodecFeatureListString,
        width: Int(config.CustomWidth),
        height: Int(config.CustomHeight),
        frameRate: Int(config.Framerate),
        source: connection.source?.description ?? "?"
      )
    }

    @discardableResult
    func stopAll() async throws -> [UInt32] {
      let response = try await device.stopMediaStream(
        with: DeviceMediaStream.StopRequest(stopAll: true, identifiers: nil))
      return response.stoppedStreams ?? []
    }

    func release() {
      assertion.releaseAssertion()
    }

    // MARK: - Negotiation

    private struct Negotiation {
      let negotiator: AVCMediaStreamNegotiator
      let offer: Data
      let startOptions: [String: CodableValue]
    }

    private static func makeNegotiator(
      kind: MediaStreamKind, deviceInfo: DeviceInfo
    ) throws -> Negotiation {
      let callID = UUID()
      let sessionID = UUID()

      var options: [String: Any] = [
        kAVCMediaStreamOptionClientName: "synk",
        kAVCMediaStreamOptionClientPID: NSNumber(
          value: ProcessInfo.processInfo.processIdentifier),
        kAVCMediaStreamOptionIsOriginator: NSNumber(value: true),
        kAVCMediaStreamOptionCallID: callID.uuidString,
        kAVCMediaStreamOptionClientSessionID: sessionID.uuidString,
      ]
      // CoreDevice decides the transport and network type for this device.
      for (key, value) in MediaStreamFunctions.getNegotiatorOptions(for: deviceInfo) {
        options[key] = value
      }

      let mode: SynkAVCMediaStreamMode =
        kind == .video ? .coreDeviceScreenSharing : .coreDeviceSystemAudio

      let negotiator: AVCMediaStreamNegotiator
      do {
        negotiator = try AVCMediaStreamNegotiator(mode: mode.rawValue, options: options)
      } catch {
        throw MediaStreamError.negotiationFailed(
          "cannot create the negotiator: \((error as NSError).localizedDescription)")
      }

      guard negotiator.createOffer(), let offer = negotiator.offer else {
        throw MediaStreamError.negotiationFailed("cannot create the offer")
      }

      // Whatever the negotiator wants the far side to know — the call ID, so
      // far. The device decodes these strictly: a call ID as a string instead
      // of a UUID is rejected with "Missing ClientName, CallID, or
      // ClientSessionID".
      var initOptions: [String: Any] = [:]
      for (key, value) in (try? negotiator.generateMediaStreamInitOptions()) ?? [:] {
        guard let key = key as? String else { continue }
        if let text = value as? String, let uuid = UUID(uuidString: text) {
          initOptions[key] = uuid
        } else {
          initOptions[key] = value
        }
      }
      initOptions[kAVCMediaStreamOptionClientName] = "synk"
      initOptions[kAVCMediaStreamOptionClientSessionID] = sessionID

      var startOptions: [String: CodableValue] = [:]
      if let wrapped = CodableValue(initOptions) {
        startOptions[DeviceMediaStream.kAVCMediaStreamInitOptions] = wrapped
      }
      startOptions[DeviceMediaStream.kAVCMediaStreamOptionClientName] = CodableValue("synk")
      startOptions[DeviceMediaStream.kAVCMediaStreamOptionClientSessionID] =
        CodableValue(sessionID)

      return Negotiation(negotiator: negotiator, offer: offer, startOptions: startOptions)
    }

    private static func finishNegotiation(
      _ negotiator: AVCMediaStreamNegotiator, answer: Data
    ) throws {
      do {
        try negotiator.setAnswer(answer)
      } catch {
        throw MediaStreamError.negotiationFailed(
          "the answer was rejected: \((error as NSError).localizedDescription)")
      }

      var error: NSError?
      var reason: NSString?
      guard SynkNegotiatorProcessAnswer(negotiator, &error, &reason) else {
        throw MediaStreamError.negotiationFailed(
          reason as String? ?? error?.localizedDescription ?? "unknown reason")
      }
    }

    // MARK: - Device lookup

    private static let managerLock = NSLock()
    private nonisolated(unsafe) static var managerTask: Task<DeviceManager, Never>?

    private static func sharedManager() -> Task<DeviceManager, Never> {
      managerLock.lock()
      defer { managerLock.unlock() }

      if let managerTask { return managerTask }
      let task = Task { () -> DeviceManager in
        let manager = DeviceManager(serviceConnection: CoreDeviceService.sharedConnection)
        await manager.awaitFullInitialization()
        return manager
      }
      managerTask = task
      return task
    }

    /// The IORegistry writes the UDID without separators, CoreDevice with one.
    private static func canonicalUDID(_ value: String) -> String {
      value.replacingOccurrences(of: "-", with: "").lowercased()
    }

    // MARK: - Networking

    /// The host end of the CoreDevice tunnel: the utun interface carrying an
    /// address in the same /48 as the device's tunnel address.
    static func hostTunnelAddress(peer: String) -> (ip: String, interface: String)? {
      let prefix = peer.split(separator: ":").prefix(3).joined(separator: ":")
      var head: UnsafeMutablePointer<ifaddrs>?
      guard getifaddrs(&head) == 0, let head else { return nil }
      defer { freeifaddrs(head) }

      var cursor: UnsafeMutablePointer<ifaddrs>? = head
      while let entry = cursor {
        defer { cursor = entry.pointee.ifa_next }
        guard let address = entry.pointee.ifa_addr,
          address.pointee.sa_family == UInt8(AF_INET6)
        else { continue }

        var buffer = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        guard
          getnameinfo(
            address, socklen_t(address.pointee.sa_len), &buffer, socklen_t(buffer.count),
            nil, 0, NI_NUMERICHOST) == 0
        else { continue }

        let ip = String(cString: buffer).split(separator: "%").first.map(String.init) ?? ""
        let name = String(cString: entry.pointee.ifa_name)
        if name.hasPrefix("utun"), ip.hasPrefix(prefix), ip != peer {
          return (ip, name)
        }
      }
      return nil
    }

    /// Binds the RTP socket on a free even port, so RTCP can have the one
    /// above it. Returns the socket together with the port it ended up on.
    static func bindReceiver(ip: String, interfaceName: String) -> (socket: Int32, port: UInt16)? {
      for _ in 0..<64 {
        guard let port = reserveEvenPort() else { return nil }
        if let socket = bindUDP(ip: ip, port: port, interfaceName: interfaceName) {
          return (socket, port)
        }
      }
      return nil
    }

    /// Picks a free even port by letting the kernel assign one and keeping it
    /// only if it is even. The socket is closed again right away; `bindUDP`
    /// takes the port for real.
    private static func reserveEvenPort() -> UInt16? {
      for _ in 0..<64 {
        let descriptor = socket(AF_INET6, SOCK_DGRAM, 0)
        guard descriptor >= 0 else { return nil }

        var address = sockaddr_in6()
        address.sin6_len = UInt8(MemoryLayout<sockaddr_in6>.size)
        address.sin6_family = sa_family_t(AF_INET6)
        let bound = withUnsafePointer(to: &address) {
          bind(
            descriptor, UnsafeRawPointer($0).assumingMemoryBound(to: sockaddr.self),
            socklen_t(MemoryLayout<sockaddr_in6>.size))
        }

        var assigned = sockaddr_in6()
        var length = socklen_t(MemoryLayout<sockaddr_in6>.size)
        let named = withUnsafeMutablePointer(to: &assigned) {
          getsockname(
            descriptor, UnsafeMutableRawPointer($0).assumingMemoryBound(to: sockaddr.self),
            &length)
        }
        close(descriptor)

        guard bound == 0, named == 0 else { continue }
        let port = UInt16(bigEndian: assigned.sin6_port)
        if port.isMultiple(of: 2), port < 65534 { return port }
      }
      return nil
    }

    /// Binds the RTP socket the device was told to send to.
    static func bindUDP(ip: String, port: UInt16, interfaceName: String) -> Int32? {
      let descriptor = socket(AF_INET6, SOCK_DGRAM, 0)
      guard descriptor >= 0 else { return nil }

      var reuse: Int32 = 1
      setsockopt(
        descriptor, SOL_SOCKET, SO_REUSEADDR, &reuse, socklen_t(MemoryLayout<Int32>.size))

      // The screen sends nothing while nothing moves, so the read loop needs a
      // timeout it can treat as "still idle" rather than blocking forever.
      var timeout = timeval(tv_sec: 1, tv_usec: 0)
      setsockopt(
        descriptor, SOL_SOCKET, SO_RCVTIMEO, &timeout, socklen_t(MemoryLayout<timeval>.size))

      // One second of 60 fps HEVC at the negotiated bitrate fits comfortably;
      // the default buffer drops packets during keyframes.
      var receiveBuffer: Int32 = 4 * 1024 * 1024
      setsockopt(
        descriptor, SOL_SOCKET, SO_RCVBUF, &receiveBuffer, socklen_t(MemoryLayout<Int32>.size))

      var address = sockaddr_in6()
      address.sin6_len = UInt8(MemoryLayout<sockaddr_in6>.size)
      address.sin6_family = sa_family_t(AF_INET6)
      address.sin6_port = port.bigEndian
      guard inet_pton(AF_INET6, ip, &address.sin6_addr) == 1 else {
        close(descriptor)
        return nil
      }
      address.sin6_scope_id = if_nametoindex(interfaceName)

      let bound = withUnsafePointer(to: &address) {
        bind(
          descriptor, UnsafeRawPointer($0).assumingMemoryBound(to: sockaddr.self),
          socklen_t(MemoryLayout<sockaddr_in6>.size))
      }
      guard bound == 0 else {
        close(descriptor)
        return nil
      }
      return descriptor
    }
  }

#endif
