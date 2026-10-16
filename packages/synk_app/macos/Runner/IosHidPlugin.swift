import FlutterMacOS
import Foundation
import os

#if arch(arm64)
  import CoreDevice
  import CoreDeviceProtocols
#endif

private let logger = Logger(subsystem: "dev.synk", category: "ios_hid")

extension Notification.Name {
  static let iosScreenWentDark = Notification.Name("dev.synk.iosScreenWentDark")
}

private let coreDeviceBinaryPath =
  "/Library/Developer/PrivateFrameworks/CoreDevice.framework/Versions/A/CoreDevice"

private let devicectlBinaryPath =
  "/Library/Developer/PrivateFrameworks/CoreDevice.framework/Versions/A/Resources/bin/devicectl"

private let isCoreDeviceAvailable: Bool = {
  #if arch(arm64)
    guard #available(macOS 14.0, *) else { return false }
    return FileManager.default.fileExists(atPath: coreDeviceBinaryPath)
  #else
    return false
  #endif
}()

#if arch(arm64)

  private let swipeSteps = 24
  private let swipeStepDuration: TimeInterval = 0.016

  @available(macOS 14.0, *)
  private final class IosHidInjector: @unchecked Sendable {
    private let queue = DispatchQueue(label: "dev.synk.ios_hid.send")

    private let managerLock = NSLock()
    private var managerTask: Task<DeviceManager, Never>?

    /// The newest position of a drag that has not reached the device yet, per
    /// device. Only one is kept: see `sendTouch`.
    private let pendingLock = NSLock()
    private var pendingMove: [String: PendingMove] = [:]

    private var digitizers: [String: any HIDDigitizer] = [:]
    private var assertions: [String: DeviceUsageAssertion] = [:]
    private var keyboards: [String: any HIDKeyboard] = [:]
    private var buttons: [String: any HIDButton] = [:]

    /// The device's last known *compositor* rotation, in degrees (0/90/180/
    /// 270). The digitizer sits below the rotation iOS applies to the
    /// mirrored image, so a touch coordinate coming from the (already
    /// rotated) mirrored frame needs to be rotated back onto the device's
    /// native, portrait frame before it reaches the digitizer. Defaults to 0
    /// (portrait, the native frame itself), so a device we have not yet heard
    /// a rotation for is left untransformed.
    ///
    /// Deliberately sourced from `devicectl device info displays` (the same
    /// data Apple's own CLI reports) rather than from CoreDevice's
    /// `OrientationControl`: the latter reflects the physical *sensor*
    /// reading, which can diverge from the actual on-screen rotation
    /// whenever the frontmost app/screen does not support the device's
    /// current physical orientation (e.g. a portrait-only screen with the
    /// device held sideways) — exactly the situation that caused touches to
    /// be mismapped.
    private var rotations: [String: Int] = [:]
    private var screenAwake: [String: Bool] = [:]
    private let refreshLock = NSLock()
    private var refreshing = Set<String>()

    // MARK: - Connection

    func prepare(udid: String) async throws -> Bool {
      let manager = await sharedManager().value

      let wanted = Self.canonicalUDID(udid)
      let device = manager.devices.values.first { device in
        guard let candidate = device.deviceInfo.udid else { return false }
        return Self.canonicalUDID(candidate) == wanted
      }

      guard let device else {
        let known = manager.devices.values.compactMap { $0.deviceInfo.udid }
        logger.info(
          """
          No touch input for \(udid, privacy: .public): CoreDevice does not know it. \
          Known devices: \(known.joined(separator: ", "), privacy: .public)
          """
        )
        return false
      }

      let assertion = try await device.acquireDeviceUsageAssertion(
        withReason: "synk mirrors this device",
        options: UsageAssertionOptions(requiredPreparedness: DevicePreparedness(rawValue: 0))
      )

      let digitizer = try await device.getImplementation(for: .hid.digitizer)
      let keyboard = try? await device.getImplementation(for: .hid.keyboard)
      if keyboard == nil {
        logger.info("No key input for \(udid, privacy: .public); touch only")
      }

      let button = try? await device.getImplementation(for: .hid.button)
      if button == nil {
        logger.info("No hardware buttons for \(udid, privacy: .public)")
      }

      queue.async {
        self.keyboards[udid] = keyboard
        self.buttons[udid] = button
        self.digitizers[udid] = digitizer
        self.assertions[udid]?.releaseAssertion()
        self.assertions[udid] = assertion
      }
      logger.info("Touch input ready for \(udid, privacy: .public)")

      refreshOrientation(udid: udid)

      return true
    }

    func release(udid: String) {
      pendingLock.lock()
      pendingMove.removeValue(forKey: udid)
      pendingLock.unlock()

      queue.async {
        self.digitizers.removeValue(forKey: udid)
        self.keyboards.removeValue(forKey: udid)
        self.buttons.removeValue(forKey: udid)
        self.rotations.removeValue(forKey: udid)
        self.screenAwake.removeValue(forKey: udid)
        self.assertions.removeValue(forKey: udid)?.releaseAssertion()
      }
    }

    /// Re-reads the device's current (compositor) rotation and caches it for
    /// the next touches. Called once a connection is prepared, and again
    /// whenever the mirrored frame's size changes — the only signal a
    /// rotation gives us, since the digitizer itself carries no orientation.
    ///
    /// Shells out to `devicectl`, which takes ~200ms: cheap enough for this
    /// refresh-on-event cadence, but far too slow to call per touch.
    func refreshOrientation(udid: String) {
      refreshLock.lock()
      let alreadyRunning = !refreshing.insert(udid).inserted
      refreshLock.unlock()
      if alreadyRunning { return }

      Task.detached(priority: .utility) {
        defer {
          self.refreshLock.lock()
          self.refreshing.remove(udid)
          self.refreshLock.unlock()
        }
        guard let state = Self.queryDisplayState(udid: udid) else { return }
        self.queue.async {
          // A release in the meantime must not be resurrected by a late result.
          guard self.digitizers[udid] != nil else { return }
          self.rotations[udid] = state.rotation
          let wasAwake = self.screenAwake[udid]
          self.screenAwake[udid] = state.awake
          if !state.awake, wasAwake != false {
            NotificationCenter.default.post(
              name: .iosScreenWentDark, object: nil, userInfo: ["udid": udid])
          }
        }
      }
    }

    /// Reads the real, on-screen rotation of the device's primary display by
    /// asking `devicectl` directly, returned as degrees (0/90/180/270).
    /// Returns `nil` if `devicectl` fails or its output cannot be parsed.
    private static func queryDisplayState(udid: String) -> (rotation: Int, awake: Bool)? {
      let process = Process()
      process.executableURL = URL(fileURLWithPath: devicectlBinaryPath)
      process.arguments = [
        "device", "info", "displays",
        "--device", Self.devicectlIdentifier(udid),
        "--json-output", "-",
      ]

      let outputPipe = Pipe()
      process.standardOutput = outputPipe
      process.standardError = Pipe()

      do {
        try process.run()
      } catch {
        logger.error(
          "devicectl failed to launch for \(udid, privacy: .public): \(error, privacy: .public)")
        return nil
      }

      let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
      process.waitUntilExit()

      guard process.terminationStatus == 0 else {
        logger.info(
          "devicectl exited \(process.terminationStatus, privacy: .public) for \(udid, privacy: .public); keeping last known rotation"
        )
        return nil
      }

      guard
        let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
        let result = json["result"] as? [String: Any],
        let displays = result["displays"] as? [[String: Any]]
      else { return nil }

      let display = displays.first { ($0["primary"] as? Bool) == true } ?? displays.first
      guard let rotationString = display?["currentOrientation"] as? String else { return nil }

      let rotation: Int
      switch rotationString {
      case "rot0": rotation = 0
      case "rot90": rotation = 90
      case "rot180": rotation = 180
      case "rot270": rotation = 270
      default: return nil
      }

      let backlight = (result["backlightState"] as? String)?.lowercased() ?? "activeon"
      let asleep = backlight.contains("off")
      logger.info("Backlight of \(udid, privacy: .public): \(backlight, privacy: .public)")
      return (rotation, !asleep)
    }

    /// `devicectl` wants the dashed form (`00008120-0009555001C2601E`); the id
    /// that reaches us has the dash stripped.
    private static func devicectlIdentifier(_ value: String) -> String {
      let compact = value.replacingOccurrences(of: "-", with: "").uppercased()
      guard compact.count == 24 else { return value }
      return "\(compact.prefix(8))-\(compact.dropFirst(8))"
    }

    private static func canonicalUDID(_ value: String) -> String {
      value.replacingOccurrences(of: "-", with: "").lowercased()
    }

    private func sharedManager() -> Task<DeviceManager, Never> {
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

    // MARK: - Sending

    /// Queues a touch for the device. Nothing waits for it to arrive.
    ///
    /// Positions of a drag are coalesced: while one is still waiting to be
    /// sent, a newer one replaces it instead of queueing behind it. Without
    /// that, a drag the queue cannot keep up with would be replayed to the
    /// device stretched out and late — and because the HID API carries no
    /// timestamp, the device would read that pacing as the finger's speed.
    /// Starts and ends are never dropped; they flush whatever position is
    /// pending first so the order of the gesture survives.
    ///
    /// Each report still ends in a barrier, which the device needs to receive
    /// it at all. Nothing on the channel waits for that any more, so its cost
    /// shows up as backpressure here rather than as a stretched gesture there.
    func sendTouch(
      udid: String,
      pointOne: DigitizerPoint,
      pointTwo: DigitizerPoint?,
      eventType: DigitizerEventType,
      edge: DigitizerEdge
    ) {
      guard eventType == .position else {
        // Claimed here rather than inside the block: a position queued after
        // this start or end must not be pulled in front of it.
        pendingLock.lock()
        let preceding = pendingMove.removeValue(forKey: udid)
        pendingLock.unlock()

        queue.async {
          if eventType == .start { self.wakeIfAsleep(udid: udid) }
          if let preceding { self.emitPendingMove(preceding, udid: udid) }
          self.report(
            self.withDigitizer(udid) { digitizer in
              try self.emit(
                digitizer,
                udid: udid,
                pointOne: pointOne,
                pointTwo: pointTwo,
                eventType: eventType,
                edge: edge
              )
            }, udid: udid)
        }
        return
      }

      pendingLock.lock()
      let alreadyQueued = pendingMove[udid] != nil
      pendingMove[udid] = PendingMove(pointOne: pointOne, pointTwo: pointTwo, edge: edge)
      pendingLock.unlock()

      // A drain is already on its way and will pick up the newer position.
      if alreadyQueued { return }
      queue.async { self.flushPendingMove(udid) }
    }

    /// Sends whatever position is pending, if a start or an end has not
    /// already claimed it.
    private func flushPendingMove(_ udid: String) {
      pendingLock.lock()
      let move = pendingMove.removeValue(forKey: udid)
      pendingLock.unlock()

      guard let move else { return }
      emitPendingMove(move, udid: udid)
    }

    private func emitPendingMove(_ move: PendingMove, udid: String) {
      report(
        withDigitizer(udid) { digitizer in
          try self.emit(
            digitizer,
            udid: udid,
            pointOne: move.pointOne,
            pointTwo: move.pointTwo,
            eventType: .position,
            edge: move.edge
          )
        }, udid: udid)
    }

    /// Nothing is waiting on a touch any more, so a failure is logged rather
    /// than handed back through the channel.
    private func report(_ error: Error?, udid: String) {
      guard let error else { return }
      logger.error(
        """
        Cannot send a touch to \(udid, privacy: .public): \
        \(error.localizedDescription, privacy: .public)
        """
      )
    }

    func sendSwipe(
      udid: String,
      from: DigitizerPoint,
      to: DigitizerPoint,
      edge: DigitizerEdge,
      hold: TimeInterval,
      completion: @escaping (Error?) -> Void
    ) {
      queue.async {
        completion(
          self.withDigitizer(udid) { digitizer in
            try self.emit(
              digitizer, udid: udid, pointOne: from, pointTwo: nil, eventType: .start, edge: edge)

            for step in 1...swipeSteps {
              Thread.sleep(forTimeInterval: swipeStepDuration)

              let progress = Double(step) / Double(swipeSteps)
              try self.emit(
                digitizer,
                udid: udid,
                pointOne: from.interpolated(to: to, at: progress),
                pointTwo: nil,
                eventType: .position,
                edge: edge
              )
            }

            if hold > 0 { Thread.sleep(forTimeInterval: hold) }
            try self.emit(
              digitizer, udid: udid, pointOne: to, pointTwo: nil, eventType: .end, edge: edge)
          })
      }
    }

    func sendKey(
      udid: String,
      usage: Int,
      isDown: Bool,
      completion: @escaping (Error?) -> Void
    ) {
      queue.async {
        guard let keyboard = self.keyboards[udid] else {
          completion(nil)
          return
        }

        do {
          try keyboard.send(
            key: HIDKeyboardUsageCode(rawValue: UInt16(usage)), state: isDown ? .down : .up)
          keyboard.sendBarrier()
          completion(nil)
        } catch {
          completion(error)
        }
      }
    }

    /// Presses sleep/wake when the last polled backlight state says the screen
    /// is off, so a touch on a sleeping device wakes it like on Android.
    /// Must run on `queue`.
    private func wakeIfAsleep(udid: String) {
      guard screenAwake[udid] == false, let button = buttons[udid] else { return }
      screenAwake[udid] = true

      do {
        try button.sendCustomButton(usagePage: 0x0c, usageCode: 0x30, state: .down)
        button.sendBarrier()
        Thread.sleep(forTimeInterval: 0.08)
        try button.sendCustomButton(usagePage: 0x0c, usageCode: 0x30, state: .up)
        button.sendBarrier()
      } catch {
        logger.error("Failed to wake \(udid, privacy: .public): \(error, privacy: .public)")
      }
    }

    func pressButton(
      udid: String,
      usagePage: Int,
      usageCode: Int,
      completion: @escaping (Error?) -> Void
    ) {
      queue.async {
        guard let button = self.buttons[udid] else {
          completion(nil)
          return
        }

        do {
          try button.sendCustomButton(usagePage: usagePage, usageCode: usageCode, state: .down)
          button.sendBarrier()
          Thread.sleep(forTimeInterval: 0.08)
          try button.sendCustomButton(usagePage: usagePage, usageCode: usageCode, state: .up)
          button.sendBarrier()
          completion(nil)
        } catch {
          completion(error)
        }
      }
    }

    // MARK: - Internals

    private func withDigitizer(
      _ udid: String,
      _ body: (any HIDDigitizer) throws -> Void
    ) -> Error? {
      guard let digitizer = digitizers[udid] else {
        return NSError(
          domain: "IosHidPlugin", code: -1,
          userInfo: [
            NSLocalizedDescriptionKey: "No HID digitizer prepared for device \(udid)."
          ]
        )
      }

      do {
        try body(digitizer)
        return nil
      } catch {
        return error
      }
    }

    private func emit(
      _ digitizer: any HIDDigitizer,
      udid: String,
      pointOne: DigitizerPoint,
      pointTwo: DigitizerPoint?,
      eventType: DigitizerEventType,
      edge: DigitizerEdge
    ) throws {
      let rotation = rotations[udid] ?? 0
      let nativeOne = Self.nativePoint(pointOne, for: rotation)

      try digitizer.send(
        pointOne: nativeOne,
        pointTwo: pointTwo.map { Self.nativePoint($0, for: rotation) },
        eventType: eventType,
        edge: Self.nativeEdge(edge, for: rotation),
        target: .mainScreen
      )


      // Every report needs this, not just the last of a gesture: without it
      // the touch does not reach the device at all. It costs a wait, but no
      // longer a visible one — the channel no longer blocks on it, and a drag
      // that outruns this queue loses stale positions to coalescing instead
      // of arriving stretched out.
      digitizer.sendBarrier()
    }

    /// Maps a point from the mirrored (already rotated) frame back onto the
    /// device's native, portrait frame, which is what the digitizer expects
    /// regardless of the device's current rotation. `rotation` is the real
    /// compositor rotation in degrees (0/90/180/270), as reported by
    /// `devicectl`; it corresponds to UIDeviceOrientation's `landscapeRight`
    /// at 90° and `landscapeLeft` at 270°. Empirically confirmed against the
    /// real device (see ROADMAP.md).
    private static func nativePoint(
      _ point: DigitizerPoint, for rotation: Int
    ) -> DigitizerPoint {
      switch rotation {
      case 90:
        return DigitizerPoint(x: point.y, y: 1 - point.x)
      case 270:
        return DigitizerPoint(x: 1 - point.y, y: point.x)
      case 180:
        return DigitizerPoint(x: 1 - point.x, y: 1 - point.y)
      default:
        return point
      }
    }

    /// Rotates an edge the same way `nativePoint` rotates a point, so a
    /// control-action swipe (e.g. bringing up the home indicator) still
    /// reaches for the correct physical edge of the device.
    private static func nativeEdge(
      _ edge: DigitizerEdge, for rotation: Int
    ) -> DigitizerEdge {
      switch rotation {
      case 90:
        switch edge {
        case .none: return .none
        case .top: return .left
        case .left: return .bottom
        case .bottom: return .right
        case .right: return .top
        }
      case 270:
        switch edge {
        case .none: return .none
        case .top: return .right
        case .right: return .bottom
        case .bottom: return .left
        case .left: return .top
        }
      case 180:
        switch edge {
        case .none: return .none
        case .top: return .bottom
        case .bottom: return .top
        case .left: return .right
        case .right: return .left
        }
      default:
        return edge
      }
    }
  }

  /// One drag position waiting its turn.
  @available(macOS 14.0, *)
  private struct PendingMove {
    let pointOne: DigitizerPoint
    let pointTwo: DigitizerPoint?
    let edge: DigitizerEdge
  }

  @available(macOS 14.0, *)
  extension DigitizerPoint {
    fileprivate func interpolated(to other: DigitizerPoint, at progress: Double) -> DigitizerPoint {
      DigitizerPoint(
        x: x + (other.x - x) * progress,
        y: y + (other.y - y) * progress
      )
    }
  }

#endif

public class IosHidPlugin: NSObject, FlutterPlugin {
  #if arch(arm64)
    private var injector: Any?
  #endif

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "dev.synk/ios_hid",
      binaryMessenger: registrar.messenger
    )

    registrar.addMethodCallDelegate(IosHidPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    #if arch(arm64)
      if isCoreDeviceAvailable, #available(macOS 14.0, *) {
        handleAvailable(call, result: result)
        return
      }
    #endif

    if call.method == "prepareInput" {
      logger.info(
        "No touch input: CoreDevice is unavailable (needs Xcode, Apple silicon, macOS 14+)")
      result("coreDeviceUnavailable")
      return
    }

    result(nil)
  }

  #if arch(arm64)

    @available(macOS 14.0, *)
    private func handleAvailable(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      let arguments = call.arguments as? [String: Any] ?? [:]

      guard let deviceId = arguments["deviceId"] as? String else {
        result(FlutterError(code: "invalid_args", message: "deviceId is required", details: nil))
        return
      }

      switch call.method {
      case "prepareInput":
        prepareInput(deviceId: deviceId, result: result)
      case "releaseInput":
        (injector as? IosHidInjector)?.release(udid: deviceId)
        result(nil)
      case "refreshOrientation":
        (injector as? IosHidInjector)?.refreshOrientation(udid: deviceId)
        result(nil)
      case "sendTouch":
        sendTouch(deviceId: deviceId, arguments: arguments, result: result)
      case "sendSwipe":
        sendSwipe(deviceId: deviceId, arguments: arguments, result: result)
      case "sendKey":
        sendKey(deviceId: deviceId, arguments: arguments, result: result)
      case "pressButton":
        pressButton(deviceId: deviceId, arguments: arguments, result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    @available(macOS 14.0, *)
    private func prepareInput(deviceId: String, result: @escaping FlutterResult) {
      let injector = (self.injector as? IosHidInjector) ?? IosHidInjector()
      self.injector = injector

      Task {
        do {
          let prepared = try await injector.prepare(udid: deviceId)
          await MainActor.run { result(prepared ? nil : "deviceUnknown") }
        } catch {
          logger.error(
            "Failed to prepare HID input for \(deviceId, privacy: .public): \(error.localizedDescription, privacy: .public)"
          )
          await MainActor.run { result("preparationFailed") }
        }
      }
    }

    @available(macOS 14.0, *)
    private func sendTouch(
      deviceId: String,
      arguments: [String: Any],
      result: @escaping FlutterResult
    ) {
      guard let injector = injector as? IosHidInjector,
        let pointOne = Self.point(from: arguments, prefix: ""),
        let eventType = Self.eventType(named: arguments["phase"] as? String)
      else {
        result(FlutterError(code: "invalid_args", message: "Invalid touch event", details: nil))
        return
      }

      injector.sendTouch(
        udid: deviceId,
        pointOne: pointOne,
        pointTwo: Self.point(from: arguments, prefix: "second"),
        eventType: eventType,
        edge: Self.edge(named: arguments["edge"] as? String)
      )

      // Answered straight away, on the thread the call arrived on. Every other
      // reply here hops through the main queue, which also carries a texture
      // notification per decoded frame — so a touch acknowledged that way
      // would be paced by the video, not by the hand that made it.
      result(nil)
    }

    @available(macOS 14.0, *)
    private func sendSwipe(
      deviceId: String,
      arguments: [String: Any],
      result: @escaping FlutterResult
    ) {
      guard let injector = injector as? IosHidInjector,
        let from = Self.point(from: arguments, prefix: "from"),
        let to = Self.point(from: arguments, prefix: "to")
      else {
        result(FlutterError(code: "invalid_args", message: "Invalid swipe", details: nil))
        return
      }

      injector.sendSwipe(
        udid: deviceId,
        from: from,
        to: to,
        edge: Self.edge(named: arguments["edge"] as? String),
        hold: Self.seconds(arguments["holdMs"]),
        completion: Self.completion(result)
      )
    }

    @available(macOS 14.0, *)
    private func sendKey(
      deviceId: String,
      arguments: [String: Any],
      result: @escaping FlutterResult
    ) {
      guard let injector = injector as? IosHidInjector,
        let usage = (arguments["usage"] as? NSNumber)?.intValue,
        let isDown = arguments["isDown"] as? Bool
      else {
        result(FlutterError(code: "invalid_args", message: "Invalid key event", details: nil))
        return
      }

      injector.sendKey(
        udid: deviceId, usage: usage, isDown: isDown, completion: Self.completion(result))
    }

    @available(macOS 14.0, *)
    private func pressButton(
      deviceId: String,
      arguments: [String: Any],
      result: @escaping FlutterResult
    ) {
      guard let injector = injector as? IosHidInjector,
        let usagePage = (arguments["usagePage"] as? NSNumber)?.intValue,
        let usageCode = (arguments["usageCode"] as? NSNumber)?.intValue
      else {
        result(FlutterError(code: "invalid_args", message: "Invalid button", details: nil))
        return
      }

      injector.pressButton(
        udid: deviceId, usagePage: usagePage, usageCode: usageCode,
        completion: Self.completion(result))
    }

    @available(macOS 14.0, *)
    private static func point(from arguments: [String: Any], prefix: String) -> DigitizerPoint? {
      guard let x = number(arguments[prefix.isEmpty ? "x" : prefix + "X"]),
        let y = number(arguments[prefix.isEmpty ? "y" : prefix + "Y"])
      else {
        return nil
      }

      return DigitizerPoint(x: x, y: y)
    }

    @available(macOS 14.0, *)
    private static func eventType(named name: String?) -> DigitizerEventType? {
      switch name {
      case "start": return .start
      case "move": return .position
      case "end": return .end
      default: return nil
      }
    }

    @available(macOS 14.0, *)
    private static func edge(named name: String?) -> DigitizerEdge {
      switch name {
      case "top": return .top
      case "bottom": return .bottom
      case "left": return .left
      case "right": return .right
      default: return .none
      }
    }

    private static func number(_ value: Any?) -> Double? {
      (value as? NSNumber)?.doubleValue
    }

    private static func seconds(_ milliseconds: Any?) -> TimeInterval {
      guard let milliseconds = number(milliseconds) else { return 0 }
      return milliseconds / 1000.0
    }

    private static func completion(_ result: @escaping FlutterResult) -> (Error?) -> Void {
      return { error in
        DispatchQueue.main.async {
          guard let error else {
            result(nil)
            return
          }

          result(
            FlutterError(
              code: "send_failed", message: error.localizedDescription, details: nil
            ))
        }
      }
    }

  #endif
}
