import AppKit
import CoreMedia
import Foundation

/// Handprobe für die Medienstrom-Schicht der App. Nutzt `CoreDeviceMediaStream`
/// und `MediaStreamRtp` direkt aus `packages/synk_app/macos/Runner`, damit es
/// nur eine Kopie der Logik gibt.
@main
struct Tool {
  static func main() async {
    let arguments = Array(CommandLine.arguments.dropFirst())
    guard let udid = arguments.first else {
      print(
        """
        usage: ./mspoc <udid> [probe|video|audio] [seconds]

          probe   Capabilities abfragen, ohne einen Strom zu starten
          video   Schirm spiegeln und dekodieren (Vorgabe)
          audio   Systemton empfangen und dekodieren
        """)
      exit(2)
    }

    guard #available(macOS 14.0, *), isCoreDeviceMediaStreamAvailable else {
      print("✗ CoreDevice oder AVConference fehlt auf diesem Mac")
      exit(1)
    }

    let command = arguments.count > 1 ? arguments[1] : "video"
    let seconds = Double(arguments.count > 2 ? arguments[2] : "10") ?? 10

    do {
      let stream = try await CoreDeviceMediaStream.connect(udid: udid)
      defer { stream.release() }

      let supported = try await stream.supportedKinds()
      print("Gerät \(udid)")
      print("  unterstützt: \(supported.sorted().joined(separator: ", "))")
      if command == "probe" { return }

      let kind: MediaStreamKind = command == "audio" ? .audio : .video
      let requested = UInt(ProcessInfo.processInfo.environment["SYNK_TIMEOUT"] ?? "")
        ?? defaultStreamTimeout
      let endpoint = try await stream.start(kind, timeout: requested)
      print("  Quelle:  \(endpoint.source)")
      print("  Payload: \(endpoint.payloadType)")
      if kind == .video {
        print("  Format:  \(endpoint.width)x\(endpoint.height) @ \(endpoint.frameRate)")
      }
      print("  Sender:  [\(endpoint.senderIP)]:\(endpoint.senderPort)")
      print("  RTCP:    aktiv=\(endpoint.rtcpEnabled) port=\(endpoint.rtcpRemotePort) "
        + "intervall=\(endpoint.rtcpSendInterval)s")
      print("  SSRC:    lokal=\(endpoint.localSSRC) fern=\(endpoint.remoteSSRC)")
      print("  Timeout: erbeten=\(requested)s zugesagt=\(endpoint.timeout)s")
      print("  Bitrate: Obergrenze=\(endpoint.maxBitrate) bit/s")
      print("  Encoder: LTR=\(endpoint.usesLongTermReference) "
        + "Kacheln=\(endpoint.tilesPerFrame) "
        + "Keyframe-Intervall=\(endpoint.keyFrameInterval)")
      print("  Codec:   \(endpoint.codecFeatures)")

      switch kind {
      case .video: await observeVideo(endpoint: endpoint, seconds: seconds)
      case .audio: await observeAudio(endpoint: endpoint, seconds: seconds)
      }

      let stopped = try await stream.stopAll()
      print("✓ gestoppt (\(stopped.count) Ströme)")
    } catch {
      print("✗ \(error.localizedDescription)")
      exit(1)
    }
  }

  @available(macOS 14.0, *)
  private static func observeVideo(endpoint: MediaStreamEndpoint, seconds: Double) async {
    let counters = Counters()
    let decoder = HevcStreamDecoder()
    // Dumping a decoded frame is the only way to tell a correct pipeline from
    // one that merely produces frames: VideoToolbox reports success on garbage.
    let dumpAt = Int(ProcessInfo.processInfo.environment["SYNK_DUMP_FRAME"] ?? "") ?? -1
    decoder.onFrame = { pixelBuffer, _ in
      let index = counters.countFrame(
        width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
      if index == 1 {
        // Flutter can only wrap an IOSurface-backed buffer into a texture.
        print("  IOSurface: \(CVPixelBufferGetIOSurface(pixelBuffer) != nil)")
      }
      if index == dumpAt { writePNG(pixelBuffer, to: "frame-\(index).png") }
      if ProcessInfo.processInfo.environment["SYNK_DUMP_LAST"] != nil { lastFrame = pixelBuffer }
      // Wie die App: einen Frame festhalten und erst viel später auslesen.
      // Wird der Puffer vom Decoder wiederverwendet, ist er dann zerstört.
      if index == dumpAt, held == nil {
        held = pixelBuffer
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
          if let buffer = held { writePNG(buffer, to: "frame-\(index)-held.png") }
          held = nil
        }
      }
    }

    // Diagnose: den zusammengesetzten Elementarstrom mitschreiben, damit ein
    // unabhängiger Decoder beurteilen kann, ob die Bytes stimmen.
    var annexB = Data()
    if ProcessInfo.processInfo.environment["SYNK_DUMP_STREAM"] != nil {
      decoder.onNalUnit = { nalUnit in
        annexB.append(contentsOf: [0, 0, 0, 1])
        annexB.append(contentsOf: nalUnit)
      }
    }

    let reporter = makeReporter(endpoint: endpoint, clockRate: HevcStreamDecoder.clockRate)
    decoder.onPacketLoss = {
      counters.countLoss()
      reporter?.requestKeyframe()
    }
    let reader = RtpSocketReader(
      socket: endpoint.socket, payloadType: endpoint.payloadType,
      onRtp: { packet in
        counters.countPacket(bytes: packet.payload.count)
        reporter?.noteRtp(packet)
        decoder.receive(packet)
      },
      onRtcp: { datagram in reporter?.noteRtcp(datagram) })

    // Diagnose: dieselben Datagramme unveraendert an einen lokalen Port
    // weiterreichen, damit ein fremder Depacketizer dasselbe sehen kann.
    if let forwardPort = UInt16(ProcessInfo.processInfo.environment["SYNK_FORWARD"] ?? "") {
      let forwarder = DatagramForwarder(port: forwardPort)
      reader.onDatagram = { forwarder.send($0) }
    }

    reader.start()
    reporter?.start()
    await report(counters: counters, seconds: seconds)
    reporter?.stop()
    reader.stop()
    decoder.invalidate()
    if !annexB.isEmpty {
      try? annexB.write(to: URL(fileURLWithPath: "stream.h265"))
      print("  → stream.h265 geschrieben (\(annexB.count) Bytes)")
    }
    if let lastFrame { writePNG(lastFrame, to: "last.png") }
    counters.summarise(label: "Frames", dropped: decoder.droppedAccessUnits)
    print("  eingereicht=\(decoder.submittedAccessUnits) Dekodierfehler=\(decoder.decodeFailures)"
      + " Intra-Frames=\(decoder.intraFrames)")
    print("  erste NAL-Typen: \(decoder.firstNalTypes)")
  }

  @available(macOS 14.0, *)
  private static func observeAudio(endpoint: MediaStreamEndpoint, seconds: Double) async {
    let counters = Counters()
    let decoder = AacEldStreamDecoder()
    // Denselben Player wie die App benutzen, nur sofort entstummt: so ist
    // hörbar, ob der Wiedergabepfad trägt, ohne die UI zu bemühen.
    let player = SystemAudioPlayer()
    player.setMuted(false)
    decoder.onSamples = { samples in
      // Ein stiller Schirm sendet winzige "inactive"-Frames, Pakete allein
      // sagen also nichts. Der Spitzenwert sagt, ob wirklich Ton drin ist.
      counters.countSamples(samples.count, peak: samples.map { abs($0) }.max() ?? 0)
      player.play(interleaved: samples)
    }

    let reporter = makeReporter(
      endpoint: endpoint, clockRate: UInt32(AacEldStreamDecoder.sampleRate))
    let reader = RtpSocketReader(
      socket: endpoint.socket, payloadType: endpoint.payloadType,
      onRtp: { packet in
        counters.countPacket()
        reporter?.noteRtp(packet)
        decoder.receive(packet)
      },
      onRtcp: { datagram in reporter?.noteRtcp(datagram) })

    reader.start()
    reporter?.start()
    try? await Task.sleep(nanoseconds: 1_500_000_000)
    print("  Wiedergabe aktiv: \(player.isLive)")
    await report(counters: counters, seconds: seconds)
    reporter?.stop()
    reader.stop()
    player.stop()
    decoder.invalidate()
    counters.summarise(label: "Samples")
  }

  @available(macOS 14.0, *)
  private static func makeReporter(
    endpoint: MediaStreamEndpoint, clockRate: UInt32, requestsKeyframes: Bool = false
  ) -> RtcpReporter? {
    guard endpoint.rtcpEnabled else { return nil }
    return RtcpReporter(
      socket: endpoint.socket, senderIP: endpoint.senderIP,
      rtcpPort: endpoint.rtcpRemotePort, interfaceName: endpoint.interfaceName,
      localSSRC: endpoint.localSSRC, remoteSSRC: endpoint.remoteSSRC,
      interval: endpoint.rtcpSendInterval, clockRate: clockRate,
      requestsKeyframes: requestsKeyframes)
  }

  private static func report(counters: Counters, seconds: Double) async {
    let deadline = Date().addingTimeInterval(seconds)
    var elapsed = 0
    while Date() < deadline {
      try? await Task.sleep(nanoseconds: 5_000_000_000)
      elapsed += 5
      counters.printInterval(at: elapsed)
    }
  }
}

/// Schiebt Datagramme unveraendert an 127.0.0.1 weiter.
private final class DatagramForwarder: @unchecked Sendable {
  private let socket: Int32
  private var destination: sockaddr_in

  init(port: UInt16) {
    socket = Darwin.socket(AF_INET, SOCK_DGRAM, 0)
    var address = sockaddr_in()
    address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    address.sin_family = sa_family_t(AF_INET)
    address.sin_port = port.bigEndian
    address.sin_addr.s_addr = inet_addr("127.0.0.1")
    destination = address
  }

  func send(_ datagram: UnsafeBufferPointer<UInt8>) {
    withUnsafePointer(to: destination) { address in
      _ = sendto(
        socket, datagram.baseAddress, datagram.count, 0,
        UnsafeRawPointer(address).assumingMemoryBound(to: sockaddr.self),
        socklen_t(MemoryLayout<sockaddr_in>.size))
    }
  }
}

nonisolated(unsafe) private var held: CVPixelBuffer?
nonisolated(unsafe) private var lastFrame: CVPixelBuffer?

private func writePNG(_ pixelBuffer: CVPixelBuffer, to name: String) {
  let image = CIImage(cvPixelBuffer: pixelBuffer)
  guard let cgImage = CIContext().createCGImage(image, from: image.extent),
    let data = NSBitmapImageRep(cgImage: cgImage).representation(using: .png, properties: [:])
  else { return }
  try? data.write(to: URL(fileURLWithPath: name))
  print("  → \(name) geschrieben")
}

/// Zähler, die der Empfangs-Thread füllt und der Hauptlauf ausliest.
private final class Counters: @unchecked Sendable {
  private let lock = NSLock()
  private var packets = 0
  private var payloadBytes = 0
  private var lastPayloadBytes = 0
  private var units = 0
  private var samples = 0
  private var peak: Float = 0
  private var firstSize: String?

  func countPacket(bytes: Int = 0) {
    lock.lock()
    packets += 1
    payloadBytes += bytes
    lock.unlock()
  }

  @discardableResult
  func countFrame(width: Int, height: Int) -> Int {
    lock.lock()
    units += 1
    let index = units
    if firstSize == nil { firstSize = "\(width)x\(height)" }
    lock.unlock()
    return index
  }

  func countSamples(_ count: Int, peak value: Float) {
    lock.lock()
    units += 1
    samples += count
    peak = max(peak, value)
    lock.unlock()
  }

  private var losses = 0
  private var lastPackets = 0
  private var lastUnits = 0

  func countLoss() {
    lock.lock()
    losses += 1
    lock.unlock()
  }

  /// Reports throughput since the previous call, which is what shows a decay.
  func printInterval(at second: Int) {
    lock.lock()
    let deltaPackets = packets - lastPackets
    let deltaUnits = units - lastUnits
    let deltaBytes = payloadBytes - lastPayloadBytes
    lastPackets = packets
    lastUnits = units
    lastPayloadBytes = payloadBytes
    let megabitsPerSecond = Double(deltaBytes) * 8 / 5 / 1_000_000
    let line = "  t+\(second)s: Pakete/s=\(deltaPackets / 5) dekodiert/s=\(deltaUnits / 5)"
      + String(format: " %.2f Mbit/s", megabitsPerSecond)
      + " Lücken=\(losses)"
      + (firstSize.map { " \($0)" } ?? "")
      + (samples > 0 ? " Spitze=\(String(format: "%.3f", peak))" : "")
    lock.unlock()
    print(line)
  }

  func summarise(label: String, dropped: Int = 0) {
    lock.lock()
    let summary = "\(label): \(units) aus \(packets) Paketen, "
      + "\(losses) Lücken, \(dropped) verworfene Zugriffseinheiten"
    lock.unlock()
    print(summary)
  }
}
