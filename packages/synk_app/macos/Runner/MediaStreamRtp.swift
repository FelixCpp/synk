import AVFoundation
import AudioToolbox
import CoreMedia
import Foundation
import VideoToolbox
import os

private let logger = Logger(subsystem: "dev.synk", category: "ios_media_stream")

/// One parsed RTP packet, pointing into the receive buffer.
struct RtpPacket {
  let payloadType: UInt8
  let hasMarker: Bool
  let timestamp: UInt32
  let sequenceNumber: UInt16
  let payload: UnsafeBufferPointer<UInt8>

  /// Parses the fixed RTP header plus any CSRC list and extension. Returns nil
  /// for anything too short to be an RTP packet — RTCP arrives multiplexed on
  /// the same socket and is filtered out by payload type, not here.
  init?(buffer: UnsafeBufferPointer<UInt8>) {
    guard buffer.count >= 12 else { return nil }
    let csrcCount = Int(buffer[0] & 0x0F)
    let hasExtension = buffer[0] & 0x10 != 0

    var offset = 12 + csrcCount * 4
    if hasExtension {
      guard buffer.count >= offset + 4 else { return nil }
      let words = Int(UInt16(buffer[offset + 2]) << 8 | UInt16(buffer[offset + 3]))
      offset += 4 + words * 4
    }
    guard buffer.count > offset else { return nil }

    payloadType = buffer[1] & 0x7F
    hasMarker = buffer[1] & 0x80 != 0
    sequenceNumber = UInt16(buffer[2]) << 8 | UInt16(buffer[3])
    timestamp =
      UInt32(buffer[4]) << 24 | UInt32(buffer[5]) << 16 | UInt32(buffer[6]) << 8
      | UInt32(buffer[7])
    payload = UnsafeBufferPointer(
      rebasing: buffer[offset..<buffer.count])
  }
}

/// Reads a bound socket on its own thread until stopped, splitting RTP from
/// the RTCP that arrives multiplexed on the same port.
///
/// The device only sends while the screen changes, so a receive timeout means
/// a quiet screen rather than a failure and the loop keeps waiting.
final class RtpSocketReader: @unchecked Sendable {
  /// In RTP/RTCP multiplexing (RFC 5761) the payload-type field of an RTCP
  /// packet lands in this range, which is why it cannot collide with RTP.
  private static let rtcpPayloadTypes: ClosedRange<UInt8> = 64...95

  private let socket: Int32
  private let payloadType: UInt8
  private let onRtp: (RtpPacket) -> Void
  private let onRtcp: (UnsafeBufferPointer<UInt8>) -> Void

  private let lock = NSLock()
  private var isRunning = false
  private var isClosed = false
  /// Signalled once the read loop has left its handlers for the last time, so
  /// `stop()` can promise that nothing is in flight any more.
  private let finished = DispatchSemaphore(value: 0)

  /// Diagnostics: every datagram, byte for byte, before any parsing.
  var onDatagram: ((UnsafeBufferPointer<UInt8>) -> Void)?

  init(
    socket: Int32,
    payloadType: UInt8,
    onRtp: @escaping (RtpPacket) -> Void,
    onRtcp: @escaping (UnsafeBufferPointer<UInt8>) -> Void = { _ in }
  ) {
    self.socket = socket
    self.payloadType = payloadType
    self.onRtp = onRtp
    self.onRtcp = onRtcp
  }

  func start() {
    lock.lock()
    guard !isRunning, !isClosed else {
      lock.unlock()
      return
    }
    isRunning = true
    lock.unlock()

    let thread = Thread { [self] in loop() }
    thread.name = "dev.synk.ios_media_stream.rtp"
    thread.qualityOfService = .userInteractive
    thread.start()
  }

  /// Stops the loop and waits for it, so callers can tear down the decoders
  /// behind the handlers without racing a packet that is still being parsed.
  func stop() {
    lock.lock()
    let wasRunning = isRunning
    isRunning = false
    // Unblocks a reader parked in recv() instead of waiting out its timeout.
    // Only safe while the loop still owns the descriptor.
    if !isClosed { shutdown(socket, SHUT_RDWR) }
    lock.unlock()

    guard wasRunning else {
      closeSocket()
      return
    }
    _ = finished.wait(timeout: .now() + 2)
  }

  private func loop() {
    // Allow for a reassembled datagram rather than silently truncating one.
    var buffer = [UInt8](repeating: 0, count: 65536)

    while true {
      lock.lock()
      let keepGoing = isRunning
      lock.unlock()
      guard keepGoing else { break }

      let received = recv(socket, &buffer, buffer.count, 0)
      if received <= 0 {
        // A timeout is the idle-screen case; anything else ends the loop so
        // the session can treat the stream as gone.
        if received < 0, errno == EAGAIN || errno == EWOULDBLOCK || errno == EINTR { continue }
        break
      }

      buffer.withUnsafeBufferPointer { raw in
        let datagram = UnsafeBufferPointer(rebasing: raw[0..<received])
        onDatagram?(datagram)
        guard datagram.count >= 2 else { return }

        let type = datagram[1] & 0x7F
        if Self.rtcpPayloadTypes.contains(type) {
          onRtcp(datagram)
          return
        }
        guard let packet = RtpPacket(buffer: datagram), packet.payloadType == payloadType
        else { return }
        onRtp(packet)
      }
    }

    closeSocket()
    finished.signal()
  }

  /// Closes the descriptor exactly once, whichever side gets there first.
  private func closeSocket() {
    lock.lock()
    let shouldClose = !isClosed
    isClosed = true
    lock.unlock()
    if shouldClose { close(socket) }
  }
}

// MARK: - RTCP

/// Sends the receiver reports the device waits for.
///
/// This is not optional politeness. Apple's sender runs its rate control off
/// RTCP, so without reports it reads the silence as a collapsing link: the
/// picture degrades into blocks, and after roughly twenty seconds the device
/// tears the stream down altogether.
final class RtcpReporter: @unchecked Sendable {
  /// RFC 3550 packet types.
  private enum PacketType {
    static let senderReport: UInt8 = 200
    static let receiverReport: UInt8 = 201
    static let sourceDescription: UInt8 = 202
    /// Payload-specific feedback (RFC 4585); format 1 is picture loss.
    static let payloadFeedback: UInt8 = 206
  }

  /// A burst of loss would otherwise produce a burst of requests.
  private static let keyframeRequestInterval: TimeInterval = 0.25

  private let socket: Int32
  private let destination: sockaddr_in6
  private let localSSRC: UInt32
  private let remoteSSRC: UInt32
  private let interval: TimeInterval
  private let clockRate: UInt32
  /// Whether this stream needs the receiver to ask for intra frames.
  private let requestsKeyframes: Bool

  private let lock = NSLock()
  private var timer: DispatchSourceTimer?
  private var isClosed = false

  // Reception statistics the report has to state.
  private var baseSequenceNumber: UInt32?
  private var highestSequenceNumber: UInt32 = 0
  private var cycles: UInt32 = 0
  private var receivedPackets: UInt32 = 0
  private var receivedAtLastReport: UInt32 = 0
  private var expectedAtLastReport: UInt32 = 0
  private var jitter: Double = 0
  private var lastRtpTimestamp: UInt32?
  private var lastArrival: TimeInterval?
  /// Middle 32 bits of the NTP stamp in the last sender report, and when it
  /// arrived — together they are the round-trip estimate the sender wants.
  private var lastSenderReport: UInt32 = 0
  private var lastSenderReportArrival: TimeInterval?
  private var lastKeyframeRequest: TimeInterval?
  /// Full intra requests carry a sequence number the sender uses to tell a
  /// repeat apart from a fresh request.
  private var fullIntraRequestCount: UInt8 = 0

  init?(
    socket: Int32, senderIP: String, rtcpPort: UInt16, interfaceName: String,
    localSSRC: UInt32, remoteSSRC: UInt32, interval: TimeInterval, clockRate: UInt32,
    requestsKeyframes: Bool = false
  ) {
    // Reports have to come from the port the device sends to, so this shares
    // the receive socket — but through its own descriptor. The reader closes
    // its copy when the stream ends, and a report must not then land in
    // whatever that descriptor number got reused for.
    let duplicated = dup(socket)
    guard duplicated >= 0 else { return nil }

    var address = sockaddr_in6()
    address.sin6_len = UInt8(MemoryLayout<sockaddr_in6>.size)
    address.sin6_family = sa_family_t(AF_INET6)
    address.sin6_port = rtcpPort.bigEndian
    guard inet_pton(AF_INET6, senderIP, &address.sin6_addr) == 1 else {
      close(duplicated)
      return nil
    }
    address.sin6_scope_id = if_nametoindex(interfaceName)

    self.socket = duplicated
    self.destination = address
    self.localSSRC = localSSRC
    self.remoteSSRC = remoteSSRC
    // A report interval of zero would busy-loop; fall back to the RFC default.
    self.interval = interval > 0 ? interval : 5
    self.clockRate = clockRate
    self.requestsKeyframes = requestsKeyframes
  }

  func start() {
    lock.lock()
    guard timer == nil else {
      lock.unlock()
      return
    }
    let timer = DispatchSource.makeTimerSource(
      queue: DispatchQueue(label: "dev.synk.ios_media_stream.rtcp"))
    timer.schedule(deadline: .now() + interval, repeating: interval)
    timer.setEventHandler { [weak self] in self?.tick() }
    self.timer = timer
    lock.unlock()
    timer.resume()
  }

  func stop() {
    lock.lock()
    let timer = self.timer
    self.timer = nil
    let shouldClose = !isClosed
    isClosed = true
    lock.unlock()

    timer?.cancel()
    // The handler runs on the timer's own queue, so wait for it to be gone
    // before dropping the descriptor it sends on.
    if let timer { timer.setEventHandler {} }
    if shouldClose { close(socket) }
  }

  /// Folds one received packet into the statistics.
  func noteRtp(_ packet: RtpPacket) {
    let arrival = Date().timeIntervalSince1970
    let sequenceNumber = UInt32(packet.sequenceNumber)

    lock.lock()
    defer { lock.unlock() }

    receivedPackets += 1
    if baseSequenceNumber == nil {
      baseSequenceNumber = sequenceNumber
      highestSequenceNumber = sequenceNumber
    } else {
      // A sequence number that jumped backwards far enough is a wrap, not
      // reordering.
      if sequenceNumber < highestSequenceNumber, highestSequenceNumber - sequenceNumber > 0x8000 {
        cycles += 1
        highestSequenceNumber = sequenceNumber
      } else if sequenceNumber > highestSequenceNumber {
        highestSequenceNumber = sequenceNumber
      }
    }

    // Interarrival jitter, smoothed as RFC 3550 prescribes.
    if let lastRtpTimestamp, let lastArrival {
      let arrivalDelta = (arrival - lastArrival) * Double(clockRate)
      let timestampDelta = Double(Int64(packet.timestamp) - Int64(lastRtpTimestamp))
      let difference = abs(arrivalDelta - timestampDelta)
      jitter += (difference - jitter) / 16
    }
    lastRtpTimestamp = packet.timestamp
    lastArrival = arrival
  }

  /// Picks the sender-report timing out of an incoming RTCP datagram.
  func noteRtcp(_ datagram: UnsafeBufferPointer<UInt8>) {
    guard datagram.count >= 16, datagram[1] == PacketType.senderReport else { return }
    // Bytes 8...15 hold the 64-bit NTP stamp; the report echoes its middle 32.
    let middle =
      UInt32(datagram[10]) << 24 | UInt32(datagram[11]) << 16
      | UInt32(datagram[12]) << 8 | UInt32(datagram[13])

    lock.lock()
    lastSenderReport = middle
    lastSenderReportArrival = Date().timeIntervalSince1970
    lock.unlock()
  }

  /// Asks the sender for a fresh intra frame, in both standard forms.
  ///
  /// Measured against iOS 27.0.1, this device acts on neither: it emits a
  /// single intra frame when the stream starts and none afterwards, whatever
  /// it is asked. The request is still the right thing to send after a loss,
  /// and costs one small packet.
  func requestKeyframe() {
    let now = Date().timeIntervalSince1970
    lock.lock()
    if let lastKeyframeRequest, now - lastKeyframeRequest < Self.keyframeRequestInterval {
      lock.unlock()
      return
    }
    lastKeyframeRequest = now
    lock.unlock()

    lock.lock()
    fullIntraRequestCount &+= 1
    let sequenceNumber = fullIntraRequestCount
    lock.unlock()

    var packet = Data()
    // Picture loss indication: the gentle form, which Apple's sender ignores
    // for this stream.
    packet.append(0x80 | 1)  // Version 2, feedback message type 1 (PLI).
    packet.append(PacketType.payloadFeedback)
    packet.appendBigEndian(UInt16(2))  // 12 bytes, in words, minus one.
    packet.appendBigEndian(localSSRC)
    packet.appendBigEndian(remoteSSRC)

    // Full intra request (RFC 5104), which it does act on.
    packet.append(0x80 | 4)  // Version 2, feedback message type 4 (FIR).
    packet.append(PacketType.payloadFeedback)
    packet.appendBigEndian(UInt16(4))  // 20 bytes, in words, minus one.
    packet.appendBigEndian(localSSRC)
    packet.appendBigEndian(UInt32(0))  // Unused for FIR.
    packet.appendBigEndian(remoteSSRC)
    packet.append(sequenceNumber)
    packet.append(contentsOf: [0, 0, 0])  // Reserved.

    transmit(packet)
  }

  private func tick() {
    transmit(buildReport())
  }

  private func transmit(_ report: Data) {
    lock.lock()
    let isUsable = !isClosed
    lock.unlock()
    guard isUsable else { return }

    report.withUnsafeBytes { bytes in
      withUnsafePointer(to: destination) { address in
        _ = sendto(
          socket, bytes.baseAddress, bytes.count, 0,
          UnsafeRawPointer(address).assumingMemoryBound(to: sockaddr.self),
          socklen_t(MemoryLayout<sockaddr_in6>.size))
      }
    }
  }

  private func buildReport() -> Data {
    lock.lock()
    let extendedHighest = cycles << 16 | (highestSequenceNumber & 0xFFFF)
    let base = baseSequenceNumber ?? 0
    let expected = extendedHighest >= base ? extendedHighest - base + 1 : 0
    let received = receivedPackets

    let expectedInterval = expected >= expectedAtLastReport ? expected - expectedAtLastReport : 0
    let receivedInterval = received >= receivedAtLastReport ? received - receivedAtLastReport : 0
    expectedAtLastReport = expected
    receivedAtLastReport = received

    let lostInterval = Int64(expectedInterval) - Int64(receivedInterval)
    let fractionLost: UInt8 =
      expectedInterval > 0 && lostInterval > 0
      ? UInt8(min(255, lostInterval * 256 / Int64(expectedInterval))) : 0
    let cumulativeLost = max(0, Int64(expected) - Int64(received))

    let jitterValue = UInt32(max(0, min(Double(UInt32.max), jitter)))
    let lastSR = lastSenderReport
    let delay: UInt32
    if let lastSenderReportArrival {
      // Delay since the last sender report, in units of 1/65536 second.
      let seconds = Date().timeIntervalSince1970 - lastSenderReportArrival
      delay = UInt32(max(0, min(Double(UInt32.max), seconds * 65536)))
    } else {
      delay = 0
    }
    lock.unlock()

    var packet = Data()

    // Receiver report with a single report block.
    packet.append(0x80 | 1)
    packet.append(PacketType.receiverReport)
    packet.appendBigEndian(UInt16(7))  // 32 bytes total, in words, minus one.
    packet.appendBigEndian(localSSRC)
    packet.appendBigEndian(remoteSSRC)
    packet.append(fractionLost)
    packet.append(UInt8(truncatingIfNeeded: cumulativeLost >> 16))
    packet.append(UInt8(truncatingIfNeeded: cumulativeLost >> 8))
    packet.append(UInt8(truncatingIfNeeded: cumulativeLost))
    packet.appendBigEndian(extendedHighest)
    packet.appendBigEndian(jitterValue)
    packet.appendBigEndian(lastSR)
    packet.appendBigEndian(delay)

    // A compound packet has to carry SDES with a CNAME; stacks that expect one
    // discard reports without it.
    packet.append(contentsOf: Self.sourceDescription(ssrc: localSSRC))
    return packet
  }

  private static func sourceDescription(ssrc: UInt32) -> [UInt8] {
    let name = Array("synk@localhost".utf8)
    var chunk: [UInt8] = []
    chunk.appendBigEndian(ssrc)
    chunk.append(1)  // CNAME
    chunk.append(UInt8(name.count))
    chunk.append(contentsOf: name)
    chunk.append(0)  // End of the item list.
    while chunk.count % 4 != 0 { chunk.append(0) }

    var packet: [UInt8] = [0x80 | 1, PacketType.sourceDescription]
    packet.appendBigEndian(UInt16(chunk.count / 4))
    packet.append(contentsOf: chunk)
    return packet
  }
}

extension Data {
  fileprivate mutating func appendBigEndian(_ value: UInt16) {
    append(UInt8(truncatingIfNeeded: value >> 8))
    append(UInt8(truncatingIfNeeded: value))
  }

  fileprivate mutating func appendBigEndian(_ value: UInt32) {
    append(UInt8(truncatingIfNeeded: value >> 24))
    append(UInt8(truncatingIfNeeded: value >> 16))
    append(UInt8(truncatingIfNeeded: value >> 8))
    append(UInt8(truncatingIfNeeded: value))
  }
}

extension Array where Element == UInt8 {
  fileprivate mutating func appendBigEndian(_ value: UInt16) {
    append(UInt8(truncatingIfNeeded: value >> 8))
    append(UInt8(truncatingIfNeeded: value))
  }

  fileprivate mutating func appendBigEndian(_ value: UInt32) {
    append(UInt8(truncatingIfNeeded: value >> 24))
    append(UInt8(truncatingIfNeeded: value >> 16))
    append(UInt8(truncatingIfNeeded: value >> 8))
    append(UInt8(truncatingIfNeeded: value))
  }
}

// MARK: - Video

/// Turns the HEVC stream a CoreDevice media stream sends into pixel buffers.
///
/// The device packetises per RFC 7798: aggregation packets (NAL type 48),
/// fragmentation units (49) and plain single NAL units. Parameter sets arrive
/// inline and are repeated, so the format description is built from the stream
/// itself rather than from the negotiation.
/// Sendable by discipline rather than by locking: `receive` is only ever
/// called from one `RtpSocketReader` thread, and `RtpSocketReader.stop()`
/// waits for that thread, so `invalidate()` never overlaps it.
final class HevcStreamDecoder: @unchecked Sendable {
  private enum NalType {
    static let vps: UInt8 = 32
    static let sps: UInt8 = 33
    static let pps: UInt8 = 34
    static let aggregationPacket: UInt8 = 48
    static let fragmentationUnit: UInt8 = 49
  }

  /// The RTP clock rate for video, fixed by RFC 7798.
  static let clockRate: UInt32 = 90_000

  private var videoParameterSet: [UInt8]?
  private var sequenceParameterSet: [UInt8]?
  private var pictureParameterSet: [UInt8]?
  private var formatDescription: CMVideoFormatDescription?
  private var decompressionSession: VTDecompressionSession?

  /// NAL units of the access unit being collected, and the partially received
  /// fragmentation unit feeding it.
  private var pendingNalUnits: [[UInt8]] = []
  private var fragment: [UInt8] = []
  private var expectedSequenceNumber: UInt16?
  /// Set when a gap hits the access unit being collected. The rest of it still
  /// arrives, but submitting what is left would hand the decoder a frame with
  /// holes — which it renders as a picture where only some regions updated.
  private var accessUnitDamaged = false

  private(set) var droppedAccessUnits = 0
  private(set) var decodeFailures = 0
  private(set) var submittedAccessUnits = 0
  /// NAL types of the first access units, for diagnosing a stream that starts
  /// mid-GOP.
  private(set) var firstNalTypes: [UInt8] = []
  /// How many intra random access pictures the stream delivered. HEVC puts
  /// them at NAL types 16 through 21.
  private(set) var intraFrames = 0

  /// Called on the receive thread for every decoded frame.
  var onFrame: ((CVPixelBuffer, CMTime) -> Void)?
  /// Called when a gap in the stream forced an access unit to be dropped.
  var onPacketLoss: (() -> Void)?
  /// Diagnostics: receives every reassembled NAL unit in order.
  var onNalUnit: (([UInt8]) -> Void)?

  func receive(_ packet: RtpPacket) {
    // A gap means a lost packet: the access unit under construction can no
    // longer be complete, so drop it rather than feed the decoder a hole.
    if let expected = expectedSequenceNumber, packet.sequenceNumber != expected {
      pendingNalUnits = []
      fragment = []
      accessUnitDamaged = true
      onPacketLoss?()
    }
    expectedSequenceNumber = packet.sequenceNumber &+ 1

    depacketize(packet.payload)
    if packet.hasMarker { completeAccessUnit(timestamp: packet.timestamp) }
  }

  private func depacketize(_ payload: UnsafeBufferPointer<UInt8>) {
    guard payload.count >= 2 else { return }

    switch (payload[0] >> 1) & 0x3F {
    case NalType.aggregationPacket:
      // PayloadHdr, then a run of (16-bit size, NAL unit) pairs.
      var cursor = 2
      while cursor + 2 <= payload.count {
        let size = Int(UInt16(payload[cursor]) << 8 | UInt16(payload[cursor + 1]))
        cursor += 2
        guard size > 0, cursor + size <= payload.count else { return }
        append(nalUnit: Array(payload[cursor..<(cursor + size)]))
        cursor += size
      }

    case NalType.fragmentationUnit:
      // PayloadHdr (2 bytes) then the FU header: start | end | type.
      guard payload.count > 3 else { return }
      let header = payload[2]
      let isStart = header & 0x80 != 0
      let isEnd = header & 0x40 != 0
      let fragmentType = header & 0x3F

      if isStart {
        // Rebuild the NAL header the fragments were split from: keep the layer
        // and temporal bits of the payload header, put the real type back.
        fragment = [(payload[0] & 0x81) | (fragmentType << 1), payload[1]]
      } else if fragment.isEmpty {
        return  // A middle fragment whose start was lost.
      }
      fragment.append(contentsOf: payload[3...])
      if isEnd {
        append(nalUnit: fragment)
        fragment = []
      }

    default:
      append(nalUnit: Array(payload))
    }
  }

  private func append(nalUnit: [UInt8]) {
    guard let first = nalUnit.first else { return }
    onNalUnit?(nalUnit)
    switch (first >> 1) & 0x3F {
    case NalType.vps: replace(&videoParameterSet, with: nalUnit)
    case NalType.sps: replace(&sequenceParameterSet, with: nalUnit)
    case NalType.pps: replace(&pictureParameterSet, with: nalUnit)
    default: pendingNalUnits.append(nalUnit)
    }
  }

  /// Parameter sets are repeated with every keyframe, so most of these are
  /// identical. A changed one means the stream reconfigured — the device was
  /// rotated, say — and the cached format description no longer describes it.
  private func replace(_ parameterSet: inout [UInt8]?, with nalUnit: [UInt8]) {
    guard parameterSet != nalUnit else { return }
    parameterSet = nalUnit
    formatDescription = nil
    invalidateSession()
  }

  /// Drops the decompression session, letting frames already in flight finish
  /// first — their callback holds an unretained reference back here.
  private func invalidateSession() {
    guard let decompressionSession else { return }
    VTDecompressionSessionWaitForAsynchronousFrames(decompressionSession)
    VTDecompressionSessionInvalidate(decompressionSession)
    self.decompressionSession = nil
  }

  private func completeAccessUnit(timestamp: UInt32) {
    defer {
      pendingNalUnits = []
      accessUnitDamaged = false
    }
    guard !accessUnitDamaged else {
      droppedAccessUnits += 1
      return
    }
    guard !pendingNalUnits.isEmpty,
      let formatDescription = resolveFormatDescription(),
      let session = resolveSession(formatDescription: formatDescription)
    else { return }

    submittedAccessUnits += 1
    if pendingNalUnits.contains(where: { (16...21).contains(($0[0] >> 1) & 0x3F) }) {
      intraFrames += 1
    }
    if firstNalTypes.count < 24 {
      firstNalTypes.append(contentsOf: pendingNalUnits.map { ($0[0] >> 1) & 0x3F })
    }

    // VideoToolbox wants length-prefixed NAL units, not Annex B start codes.
    var payload: [UInt8] = []
    payload.reserveCapacity(pendingNalUnits.reduce(0) { $0 + $1.count + 4 })
    for nalUnit in pendingNalUnits {
      let size = UInt32(nalUnit.count)
      payload.append(UInt8(truncatingIfNeeded: size >> 24))
      payload.append(UInt8(truncatingIfNeeded: size >> 16))
      payload.append(UInt8(truncatingIfNeeded: size >> 8))
      payload.append(UInt8(truncatingIfNeeded: size))
      payload.append(contentsOf: nalUnit)
    }

    guard
      let sampleBuffer = Self.makeSampleBuffer(
        payload: payload, formatDescription: formatDescription,
        presentationTime: CMTime(
          value: CMTimeValue(timestamp), timescale: CMTimeScale(Self.clockRate)))
    else { return }

    let status = VTDecompressionSessionDecodeFrame(
      session, sampleBuffer: sampleBuffer,
      flags: [._EnableAsynchronousDecompression], frameRefcon: nil, infoFlagsOut: nil)
    if status != noErr { decodeFailures += 1 }
  }

  private func resolveFormatDescription() -> CMVideoFormatDescription? {
    if let formatDescription { return formatDescription }
    guard let videoParameterSet, let sequenceParameterSet, let pictureParameterSet else {
      return nil
    }

    var created: CMFormatDescription?
    let status = videoParameterSet.withUnsafeBufferPointer { vps in
      sequenceParameterSet.withUnsafeBufferPointer { sps in
        pictureParameterSet.withUnsafeBufferPointer { pps in
          let pointers = [vps.baseAddress!, sps.baseAddress!, pps.baseAddress!]
          let sizes = [vps.count, sps.count, pps.count]
          return pointers.withUnsafeBufferPointer { pointerList in
            sizes.withUnsafeBufferPointer { sizeList in
              CMVideoFormatDescriptionCreateFromHEVCParameterSets(
                allocator: kCFAllocatorDefault, parameterSetCount: 3,
                parameterSetPointers: pointerList.baseAddress!,
                parameterSetSizes: sizeList.baseAddress!, nalUnitHeaderLength: 4,
                extensions: nil, formatDescriptionOut: &created)
            }
          }
        }
      }
    }

    guard status == noErr, let created else {
      logger.error("Cannot build the HEVC format description: \(status)")
      return nil
    }
    formatDescription = created
    return created
  }

  private func resolveSession(formatDescription: CMVideoFormatDescription)
    -> VTDecompressionSession?
  {
    if let decompressionSession { return decompressionSession }

    var callback = VTDecompressionOutputCallbackRecord(
      decompressionOutputCallback: { refcon, _, status, _, imageBuffer, presentationTime, _ in
        guard let refcon else { return }
        let decoder = Unmanaged<HevcStreamDecoder>.fromOpaque(refcon).takeUnretainedValue()
        guard status == noErr, let imageBuffer else {
          decoder.decodeFailures += 1
          return
        }
        decoder.onFrame?(imageBuffer, presentationTime)
      },
      decompressionOutputRefCon: Unmanaged.passUnretained(self).toOpaque())

    // BGRA keeps the Flutter texture path identical to the capture-session one.
    //
    // Flutter wraps the buffer in a Metal texture through its IOSurface. The
    // hardware decoder happens to back its buffers that way already, but
    // asking is what makes that a guarantee rather than an observation.
    let attributes: [CFString: Any] = [
      kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA,
      kCVPixelBufferIOSurfacePropertiesKey: [CFString: Any](),
      kCVPixelBufferMetalCompatibilityKey: true,
    ]

    var session: VTDecompressionSession?
    let status = VTDecompressionSessionCreate(
      allocator: kCFAllocatorDefault, formatDescription: formatDescription,
      decoderSpecification: nil, imageBufferAttributes: attributes as CFDictionary,
      outputCallback: &callback, decompressionSessionOut: &session)

    guard status == noErr else {
      logger.error("Cannot create the HEVC decompression session: \(status)")
      return nil
    }
    decompressionSession = session
    return session
  }

  private static func makeSampleBuffer(
    payload: [UInt8], formatDescription: CMVideoFormatDescription, presentationTime: CMTime
  ) -> CMSampleBuffer? {
    let block = UnsafeMutablePointer<UInt8>.allocate(capacity: payload.count)
    block.update(from: payload, count: payload.count)

    var blockBuffer: CMBlockBuffer?
    var status = CMBlockBufferCreateWithMemoryBlock(
      allocator: kCFAllocatorDefault, memoryBlock: block, blockLength: payload.count,
      blockAllocator: kCFAllocatorDefault, customBlockSource: nil, offsetToData: 0,
      dataLength: payload.count, flags: 0, blockBufferOut: &blockBuffer)
    guard status == noErr, let blockBuffer else {
      block.deallocate()
      return nil
    }

    var timing = CMSampleTimingInfo(
      duration: .invalid, presentationTimeStamp: presentationTime, decodeTimeStamp: .invalid)
    var sampleSize = payload.count
    var sampleBuffer: CMSampleBuffer?
    status = CMSampleBufferCreateReady(
      allocator: kCFAllocatorDefault, dataBuffer: blockBuffer,
      formatDescription: formatDescription, sampleCount: 1, sampleTimingEntryCount: 1,
      sampleTimingArray: &timing, sampleSizeEntryCount: 1, sampleSizeArray: &sampleSize,
      sampleBufferOut: &sampleBuffer)
    guard status == noErr else { return nil }
    return sampleBuffer
  }

  func invalidate() {
    invalidateSession()
  }
}

// MARK: - Audio

/// Turns the system-audio stream into PCM buffers.
///
/// The device negotiates AAC-ELD at 48 kHz stereo with 10 ms frames, one frame
/// per RTP packet. Silence is sent as a tiny inactive frame rather than being
/// dropped, so packet flow alone says nothing about whether anything is
/// audible.
/// Sendable under the same discipline as `HevcStreamDecoder`.
final class AacEldStreamDecoder: @unchecked Sendable {
  static let sampleRate: Double = 48_000
  static let channelCount: UInt32 = 2
  /// 10 ms at 48 kHz.
  static let framesPerPacket: UInt32 = 480
  /// Comfortably above a 10 ms AAC-ELD frame at any negotiated bitrate.
  private static let maxFrameBytes = 4096

  private var converter: AudioConverterRef?
  /// Owned, stable storage for the frame being decoded. The converter callback
  /// hands this pointer to CoreAudio, so it must outlive the callback — a
  /// pointer into a Swift array would not.
  private let inputFrame = UnsafeMutablePointer<UInt8>.allocate(
    capacity: AacEldStreamDecoder.maxFrameBytes)
  private var inputFrameSize: UInt32 = 0
  /// Also owned storage: CoreAudio keeps the pointer we hand it, so the
  /// description cannot live on the stack either.
  private let packetDescription = UnsafeMutablePointer<AudioStreamPacketDescription>
    .allocate(capacity: 1)
  private var pendingFrame = false
  private var outputSamples: [Float]

  /// Called on the receive thread with interleaved float samples.
  var onSamples: (([Float]) -> Void)?

  init() {
    outputSamples = [Float](
      repeating: 0, count: Int(Self.framesPerPacket) * Int(Self.channelCount))
  }

  deinit {
    inputFrame.deallocate()
    packetDescription.deallocate()
  }

  var outputFormat: AudioStreamBasicDescription {
    var format = AudioStreamBasicDescription()
    format.mSampleRate = Self.sampleRate
    format.mFormatID = kAudioFormatLinearPCM
    format.mFormatFlags = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked
    format.mChannelsPerFrame = Self.channelCount
    format.mBitsPerChannel = 32
    format.mFramesPerPacket = 1
    format.mBytesPerFrame = 4 * Self.channelCount
    format.mBytesPerPacket = format.mBytesPerFrame
    return format
  }

  func receive(_ packet: RtpPacket) {
    guard let converter = resolveConverter(),
      packet.payload.count > 0, packet.payload.count <= Self.maxFrameBytes
    else { return }

    inputFrame.update(from: packet.payload.baseAddress!, count: packet.payload.count)
    inputFrameSize = UInt32(packet.payload.count)
    packetDescription.pointee = AudioStreamPacketDescription(
      mStartOffset: 0, mVariableFramesInPacket: 0, mDataByteSize: inputFrameSize)
    pendingFrame = true

    var outputFrames = Self.framesPerPacket
    let status = outputSamples.withUnsafeMutableBufferPointer { output -> OSStatus in
      var bufferList = AudioBufferList(
        mNumberBuffers: 1,
        mBuffers: AudioBuffer(
          mNumberChannels: Self.channelCount,
          mDataByteSize: UInt32(output.count * MemoryLayout<Float>.size),
          mData: output.baseAddress))

      return AudioConverterFillComplexBuffer(
        converter, { _, numberOfPackets, bufferList, packetDescriptions, userData in
          guard let userData else { return kAudioConverterErr_UnspecifiedError }
          let decoder = Unmanaged<AacEldStreamDecoder>
            .fromOpaque(userData).takeUnretainedValue()

          // One RTP packet is one AAC-ELD frame: hand it over once, then say
          // there is nothing more so the converter returns instead of blocking.
          guard decoder.pendingFrame else {
            numberOfPackets.pointee = 0
            return noErr
          }
          decoder.pendingFrame = false

          numberOfPackets.pointee = 1
          bufferList.pointee.mNumberBuffers = 1
          bufferList.pointee.mBuffers.mNumberChannels = AacEldStreamDecoder.channelCount
          bufferList.pointee.mBuffers.mDataByteSize = decoder.inputFrameSize
          bufferList.pointee.mBuffers.mData = UnsafeMutableRawPointer(decoder.inputFrame)
          packetDescriptions?.pointee = decoder.packetDescription
          return noErr
        }, Unmanaged.passUnretained(self).toOpaque(), &outputFrames, &bufferList, nil)
    }

    guard status == noErr, outputFrames > 0 else {
      if status != noErr { logger.debug("AAC-ELD decode returned \(status)") }
      return
    }

    let sampleCount = min(Int(outputFrames) * Int(Self.channelCount), outputSamples.count)
    onSamples?(Array(outputSamples[0..<sampleCount]))
  }

  private func resolveConverter() -> AudioConverterRef? {
    if let converter { return converter }

    var input = AudioStreamBasicDescription()
    input.mSampleRate = Self.sampleRate
    input.mFormatID = kAudioFormatMPEG4AAC_ELD
    input.mChannelsPerFrame = Self.channelCount
    input.mFramesPerPacket = Self.framesPerPacket

    var output = outputFormat
    var created: AudioConverterRef?
    let status = AudioConverterNew(&input, &output, &created)
    guard status == noErr, let created else {
      logger.error("Cannot create the AAC-ELD converter: \(status)")
      return nil
    }
    converter = created
    return created
  }

  func invalidate() {
    guard let converter else { return }
    AudioConverterDispose(converter)
    self.converter = nil
  }
}

/// Plays the device's system audio on the Mac.
///
/// Starts muted on purpose: a mirror that makes noise the moment it connects
/// is worse than one the user unmutes.
final class SystemAudioPlayer: @unchecked Sendable {
  private let lock = NSLock()
  private var isMuted = true
  private var engine: AVAudioEngine?
  private var player: AVAudioPlayerNode?
  private var format: AVAudioFormat?
  /// Logged once, so a broken engine says so instead of just staying silent.
  private var hasReportedFailure = false

  func setMuted(_ muted: Bool) {
    lock.lock()
    isMuted = muted
    let player = self.player
    lock.unlock()

    if muted { player?.stop() }
  }

  /// Takes interleaved frames as the decoder produces them.
  func play(interleaved samples: [Float]) {
    lock.lock()
    guard !isMuted else {
      lock.unlock()
      return
    }
    let resolved = resolveLocked()
    lock.unlock()

    guard let (engine, player, format) = resolved else { return }

    let channelCount = Int(format.channelCount)
    let frameCount = samples.count / channelCount
    guard frameCount > 0,
      let buffer = AVAudioPCMBuffer(
        pcmFormat: format, frameCapacity: AVAudioFrameCount(frameCount)),
      let channels = buffer.floatChannelData
    else { return }

    buffer.frameLength = AVAudioFrameCount(frameCount)
    // The engine runs on non-interleaved buffers, so split the channels apart
    // rather than handing it one packed block.
    for channel in 0..<channelCount {
      let destination = channels[channel]
      for frame in 0..<frameCount {
        destination[frame] = samples[frame * channelCount + channel]
      }
    }

    if !engine.isRunning {
      do {
        try engine.start()
      } catch {
        report("Cannot start the audio engine: \(error.localizedDescription)")
        return
      }
    }
    player.scheduleBuffer(buffer)
    if !player.isPlaying { player.play() }
  }

  /// Must be called with `lock` held.
  private func resolveLocked() -> (AVAudioEngine, AVAudioPlayerNode, AVAudioFormat)? {
    if let engine, let player, let format { return (engine, player, format) }

    guard
      let format = AVAudioFormat(
        commonFormat: .pcmFormatFloat32,
        sampleRate: AacEldStreamDecoder.sampleRate,
        channels: AacEldStreamDecoder.channelCount,
        interleaved: false)
    else {
      report("Cannot describe the audio format")
      return nil
    }

    let engine = AVAudioEngine()
    let player = AVAudioPlayerNode()
    engine.attach(player)
    // Connecting through the mixer lets it resample to whatever the Mac's
    // current output device runs at.
    engine.connect(player, to: engine.mainMixerNode, format: format)
    engine.prepare()

    self.engine = engine
    self.player = player
    self.format = format
    return (engine, player, format)
  }

  /// Whether sound is actually on its way to the Mac's output device.
  var isLive: Bool {
    lock.lock()
    defer { lock.unlock() }
    return engine?.isRunning == true && player?.isPlaying == true
  }

  func stop() {
    lock.lock()
    let player = self.player
    let engine = self.engine
    self.player = nil
    self.engine = nil
    self.format = nil
    lock.unlock()

    player?.stop()
    engine?.stop()
  }

  private func report(_ message: String) {
    lock.lock()
    let shouldReport = !hasReportedFailure
    hasReportedFailure = true
    lock.unlock()
    if shouldReport { logger.error("\(message, privacy: .public)") }
  }
}
