import CoreDevice
import Foundation

func edge(_ name: String) -> DigitizerEdge {
  switch name {
  case "top": return .top
  case "bottom": return .bottom
  case "left": return .left
  case "right": return .right
  default: return .none
  }
}

let consumerCodes: [(String, HIDUsageCode<ConsumerPage>)] = [
  ("sleepWake", .sleepWake),
  ("power", .power),
  ("home", .home),
  ("menu", .menu),
  ("siri", .siri),
  ("snapshot", .snapshot),
  ("volumeIncrement", .volumeIncrement),
  ("volumeDecrement", .volumeDecrement),
]

func statePair(reversed: Bool) -> (HIDButtonState, HIDButtonState) {
  reversed ? (.up, .down) : (.down, .up)
}

func number(_ text: String) -> Int {
  if text.hasPrefix("0x") || text.hasPrefix("0X") {
    return Int(text.dropFirst(2), radix: 16) ?? 0
  }
  return Int(text) ?? 0
}

@main
struct Tool {
  static func main() async {
    let args = Array(CommandLine.arguments.dropFirst())
    let manager = DeviceManager(serviceConnection: CoreDeviceService.sharedConnection)
    await manager.awaitFullInitialization()
    guard let dev = manager.devices.values.first else { print("no device"); return }

    do {
      let assertion = try await dev.acquireDeviceUsageAssertion(
        withReason: "synk HID spike",
        options: UsageAssertionOptions(requiredPreparedness: DevicePreparedness(rawValue: 0)))
      defer { assertion.releaseAssertion() }

      switch args.first {
      case "assert":
        let assertion = try await dev.acquireDeviceUsageAssertion(
          withReason: "synk HID spike",
          options: UsageAssertionOptions(requiredPreparedness: DevicePreparedness(rawValue: 0)))
        print("assertion: \(assertion.identifier)")
        do { _ = try await dev.getImplementation(for: .hid.digitizer); print("  digitizer: ok") }
        catch { print("  digitizer: \((error as NSError).localizedDescription)") }
        do { _ = try await dev.getImplementation(for: .hid.keyboard); print("  keyboard:  ok") }
        catch { print("  keyboard:  \((error as NSError).localizedDescription)") }
        assertion.releaseAssertion()

      case "probe":
        print("device: \(dev.deviceInfo.udid ?? "?")")
        do { _ = try await dev.getImplementation(for: .hid.digitizer); print("  digitizer: ok") }
        catch { print("  digitizer: \((error as NSError).localizedDescription)") }
        do { _ = try await dev.getImplementation(for: .hid.keyboard); print("  keyboard:  ok") }
        catch { print("  keyboard:  \((error as NSError).localizedDescription)") }
        do { _ = try await dev.getImplementation(for: .hid.button); print("  button:    ok") }
        catch { print("  button:    \((error as NSError).localizedDescription)") }

      case "orient":
        let control = try await dev.getImplementation(for: .orientationControl)
        let info = try await control.currentDeviceOrientation()
        print("currentDeviceOrientation: \(info.currentDeviceOrientation)")
        print("currentDeviceNonFlatOrientation: \(info.currentDeviceNonFlatOrientation)")
        print("currentDeviceOrientationLocked: \(info.currentDeviceOrientationLocked)")

      case "setorient":
        let name = args[1]
        let target: DeviceOrientation
        switch name {
        case "portrait": target = .portrait
        case "portraitUpsideDown": target = .portraitUpsideDown
        case "landscapeLeft": target = .landscapeLeft
        case "landscapeRight": target = .landscapeRight
        case "faceUp": target = .faceUp
        case "faceDown": target = .faceDown
        default: print("unknown orientation: \(name)"); return
        }
        let control = try await dev.getImplementation(for: .orientationControl)
        let info = try await control.changeDeviceOrientation(target)
        print("changeDeviceOrientation(\(name)) -> currentDeviceOrientation: \(info.currentDeviceOrientation), nonFlat: \(info.currentDeviceNonFlatOrientation)")

      case "scroll":
        let dy = Double(args[1])!
        let target = ScrollTarget(rawValue: UInt(args.count > 2 ? args[2] : "0")!)!
        let steps = 10
        let scroll = try await dev.getImplementation(for: .hid.scroll)
        let none = ScrollMomentum(rawValue: 0)
        try scroll.send(
          point: ScrollPoint(x: 0.0, y: dy / Double(steps), z: 0.0),
          phase: ScrollPhase(rawValue: 1), momentum: none, target: target)
        scroll.sendBarrier()
        for _ in 1...steps {
          try await Task.sleep(nanoseconds: 16_000_000)
          try scroll.send(
            point: ScrollPoint(x: 0.0, y: dy / Double(steps), z: 0.0),
            phase: ScrollPhase(rawValue: 2), momentum: none, target: target)
          scroll.sendBarrier()
        }
        try scroll.send(
          point: ScrollPoint(x: 0.0, y: 0.0, z: 0.0),
          phase: ScrollPhase(rawValue: 4), momentum: none, target: target)
        scroll.sendBarrier()
        print("scroll dy=\(dy) target=\(target.rawValue)")

      case "scrollinfo":
        print("ScrollTarget.dial = \(ScrollTarget.dial.rawValue), digitalCrown = \(ScrollTarget.digitalCrown.rawValue)")
        for raw in UInt(0)...6 {
          print("  target \(raw): \(ScrollTarget(rawValue: raw) == nil ? "-" : "gueltig")")
        }
        for raw in UInt16(0)...10 {
          print("  phase \(raw): \(ScrollPhase(rawValue: raw).description)")
        }
        for raw in UInt8(0)...6 {
          print("  momentum \(raw): \(ScrollMomentum(rawValue: raw).description)")
        }

      case "pages":
        print("ConsumerPage.usagePage = 0x\(String(ConsumerPage.usagePage, radix: 16))")
        for (name, code) in consumerCodes {
          print(
            "  \(name): page=0x\(String(code.usagePage, radix: 16))"
              + " code=0x\(String(code.usageCode, radix: 16))")
        }

      case "button":
        let name = args[1]
        guard let code = consumerCodes.first(where: { $0.0 == name })?.1 else {
          print("unknown button: \(name)")
          return
        }
        let reversed = args.count > 2 && args[2] == "reverse"
        let (first, second) = statePair(reversed: reversed)
        let btn = try await dev.getImplementation(for: .hid.button)
        try btn.sendCustomButton(
          usagePage: Int(code.usagePage), usageCode: Int(code.usageCode), state: first)
        btn.sendBarrier()
        try await Task.sleep(nanoseconds: 80_000_000)
        try btn.sendCustomButton(
          usagePage: Int(code.usagePage), usageCode: Int(code.usageCode), state: second)
        btn.sendBarrier()
        print("button \(name) page=0x\(String(code.usagePage, radix: 16))"
          + " code=0x\(String(code.usageCode, radix: 16))"
          + " order=\(reversed ? "up,down" : "down,up")")

      case "rawbutton":
        let page = number(args[1])
        let code = number(args[2])
        let reversed = args.count > 3 && args[3] == "reverse"
        let (first, second) = statePair(reversed: reversed)
        let btn = try await dev.getImplementation(for: .hid.button)
        try btn.sendCustomButton(usagePage: page, usageCode: code, state: first)
        btn.sendBarrier()
        try await Task.sleep(nanoseconds: 80_000_000)
        try btn.sendCustomButton(usagePage: page, usageCode: code, state: second)
        btn.sendBarrier()
        print("rawbutton page=\(page) code=\(code) order=\(reversed ? "up,down" : "down,up")")

      case "key":
        let usage = number(args[1])
        let reversed = args.count > 2 && args[2] == "reverse"
        let (first, second) = statePair(reversed: reversed)
        let kbd = try await dev.getImplementation(for: .hid.keyboard)
        try kbd.send(key: HIDKeyboardUsageCode(rawValue: UInt16(usage)), state: first)
        kbd.sendBarrier()
        try await Task.sleep(nanoseconds: 40_000_000)
        try kbd.send(key: HIDKeyboardUsageCode(rawValue: UInt16(usage)), state: second)
        kbd.sendBarrier()
        print("key usage=0x\(String(usage, radix: 16)) order=\(reversed ? "up,down" : "down,up")")

      case "type":
        let text = args[1]
        let reversed = args.count > 2 && args[2] == "reverse"
        let (first, second) = statePair(reversed: reversed)
        let kbd = try await dev.getImplementation(for: .hid.keyboard)
        for character in text.lowercased() {
          guard let usage = keyboardUsage(for: character) else {
            print("no usage code for '\(character)'")
            continue
          }
          try kbd.send(key: HIDKeyboardUsageCode(rawValue: UInt16(usage)), state: first)
          kbd.sendBarrier()
          try await Task.sleep(nanoseconds: 30_000_000)
          try kbd.send(key: HIDKeyboardUsageCode(rawValue: UInt16(usage)), state: second)
          kbd.sendBarrier()
          try await Task.sleep(nanoseconds: 30_000_000)
        }
        print("type \"\(text)\" order=\(reversed ? "up,down" : "down,up")")

      case "tap":
        let x = Double(args[1])!, y = Double(args[2])!
        let dig = try await dev.getImplementation(for: .hid.digitizer)
        let p = DigitizerPoint(x: x, y: y)
        try dig.send(pointOne: p, pointTwo: nil, eventType: .start, edge: .none, target: .mainScreen)
        try await Task.sleep(nanoseconds: 60_000_000)
        try dig.send(pointOne: p, pointTwo: nil, eventType: .end, edge: .none, target: .mainScreen)
        dig.sendBarrier()
        print("tap \(x),\(y)")

      case "drag":
        let x1 = Double(args[1])!, y1 = Double(args[2])!
        let x2 = Double(args[3])!, y2 = Double(args[4])!
        let e = edge(args.count > 5 ? args[5] : "none")
        let dig = try await dev.getImplementation(for: .hid.digitizer)
        let steps = 24
        try dig.send(pointOne: DigitizerPoint(x: x1, y: y1), pointTwo: nil,
                     eventType: .start, edge: e, target: .mainScreen)
        dig.sendBarrier()
        try await Task.sleep(nanoseconds: 16_000_000)
        for i in 1...steps {
          let t = Double(i) / Double(steps)
          let p = DigitizerPoint(x: x1 + (x2 - x1) * t, y: y1 + (y2 - y1) * t)
          try dig.send(pointOne: p, pointTwo: nil, eventType: .position, edge: e, target: .mainScreen)
          dig.sendBarrier()
          try await Task.sleep(nanoseconds: 16_000_000)
        }
        try dig.send(pointOne: DigitizerPoint(x: x2, y: y2), pointTwo: nil,
                     eventType: .end, edge: e, target: .mainScreen)
        dig.sendBarrier()
        print("drag \(x1),\(y1) -> \(x2),\(y2) edge=\(args.count > 5 ? args[5] : "none")")

      case "pinch":
        let cx = Double(args[1])!, cy = Double(args[2])!
        let d0 = Double(args[3])!, d1 = Double(args[4])!
        let dig = try await dev.getImplementation(for: .hid.digitizer)
        let steps = 24
        func points(_ d: Double) -> (DigitizerPoint, DigitizerPoint) {
          (DigitizerPoint(x: cx - d, y: cy), DigitizerPoint(x: cx + d, y: cy))
        }
        var (a, b) = points(d0)
        try dig.send(pointOne: a, pointTwo: b, eventType: .start, edge: .none, target: .mainScreen)
        dig.sendBarrier()
        try await Task.sleep(nanoseconds: 16_000_000)
        for i in 1...steps {
          let t = Double(i) / Double(steps)
          (a, b) = points(d0 + (d1 - d0) * t)
          try dig.send(pointOne: a, pointTwo: b, eventType: .position, edge: .none, target: .mainScreen)
          dig.sendBarrier()
          try await Task.sleep(nanoseconds: 16_000_000)
        }
        try dig.send(pointOne: a, pointTwo: b, eventType: .end, edge: .none, target: .mainScreen)
        dig.sendBarrier()
        print("pinch \(d0) -> \(d1)")

      default:
        print("""
          usage:
            hidpoc pages
            hidpoc button <name> [reverse]
            hidpoc rawbutton <page> <code> [reverse]
            hidpoc key <usage> [reverse]
            hidpoc type <text> [reverse]
            hidpoc tap X Y
            hidpoc drag X1 Y1 X2 Y2 [edge]
            hidpoc pinch CX CY D0 D1
          """)
      }
      try? await Task.sleep(nanoseconds: 2_000_000_000)
    } catch {
      print("error: \(error)")
      print("""

        Hinweis: "not supported by this device" meldet CoreDevice auch dann, wenn das
        Gerät die Capability zwar listet, sie aber gerade nicht hergibt. Gegenprobe:
        `hidpoc tap 0.5 0.5` – schlägt der Digitizer mit derselben Meldung fehl, liegt
        es am Gerätezustand (Schirm aus / gesperrt), nicht an der Capability.
        """)
    }
  }
}

func keyboardUsage(for character: Character) -> Int? {
  if let ascii = character.asciiValue {
    if ascii >= 97 && ascii <= 122 { return 0x04 + Int(ascii - 97) }
    if ascii >= 49 && ascii <= 57 { return 0x1E + Int(ascii - 49) }
    if ascii == 48 { return 0x27 }
    if ascii == 32 { return 0x2C }
  }
  return nil
}
