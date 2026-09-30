import AVFoundation
import Cocoa
import FlutterMacOS
import IOKit

private func handleIterator(_ iterator: io_iterator_t, _ body: (io_object_t) -> Void) {
  var device = IOIteratorNext(iterator)
  while device != 0 {
    body(device)
    IOObjectRelease(device)
    device = IOIteratorNext(iterator)
  }
}

private func stringProperty(_ device: io_object_t, _ key: String) -> String? {
  guard
    let value = IORegistryEntryCreateCFProperty(
      device, key as CFString, kCFAllocatorDefault, 0
    )?.takeRetainedValue()
  else {
    return nil
  }

  return value as? String
}

private func isIosDevice(_ device: io_object_t) -> Bool {
  IORegistryEntryCreateCFProperty(
    device, "SupportsIPhoneOS" as CFString, kCFAllocatorDefault, 0
  )?.takeRetainedValue() != nil
}

private func resolveFriendlyName(fallback: String?) -> String? {
  guard #available(macOS 14.0, *) else { return fallback }

  let discovery = AVCaptureDevice.DiscoverySession(
    deviceTypes: [.external],
    mediaType: .muxed,
    position: .unspecified
  )

  guard discovery.devices.count == 1, let device = discovery.devices.first else {
    return fallback
  }

  return device.localizedName
}

public class IosDeviceDiscoveryPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  private var notificationPort: IONotificationPortRef?
  private var addedIterator: io_iterator_t = 0
  private var removedIterator: io_iterator_t = 0

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = IosDeviceDiscoveryPlugin()
    let channel = FlutterEventChannel(
      name: "dev.deviceviewer/ios_devices",
      binaryMessenger: registrar.messenger
    )
    channel.setStreamHandler(instance)
  }

  public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink)
    -> FlutterError?
  {
    self.eventSink = eventSink
    startWatching()
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    stopWatching()
    eventSink = nil
    return nil
  }

  private func startWatching() {
    let port = IONotificationPortCreate(kIOMainPortDefault)
    notificationPort = port
    CFRunLoopAddSource(
      CFRunLoopGetMain(),
      IONotificationPortGetRunLoopSource(port).takeUnretainedValue(),
      .defaultMode
    )

    let observer = Unmanaged.passUnretained(self).toOpaque()

    guard let addedMatchingDict = IOServiceMatching("IOUSBHostDevice") else { return }

    IOServiceAddMatchingNotification(
      port,
      kIOFirstMatchNotification,
      addedMatchingDict,
      { refCon, iterator in
        let plugin = Unmanaged<IosDeviceDiscoveryPlugin>.fromOpaque(refCon!)
          .takeUnretainedValue()
        plugin.handleAttached(iterator: iterator)
      },
      observer,
      &addedIterator
    )
    handleAttached(iterator: addedIterator)

    guard let removedMatchingDict = IOServiceMatching("IOUSBHostDevice") else { return }

    IOServiceAddMatchingNotification(
      port,
      kIOTerminatedNotification,
      removedMatchingDict,
      { refCon, iterator in
        let plugin = Unmanaged<IosDeviceDiscoveryPlugin>.fromOpaque(refCon!)
          .takeUnretainedValue()
        plugin.handleDetached(iterator: iterator)
      },
      observer,
      &removedIterator
    )
    handleDetached(iterator: removedIterator)
  }

  private func stopWatching() {
    if addedIterator != 0 {
      IOObjectRelease(addedIterator)
      addedIterator = 0
    }
    if removedIterator != 0 {
      IOObjectRelease(removedIterator)
      removedIterator = 0
    }
    if let port = notificationPort {
      CFRunLoopRemoveSource(
        CFRunLoopGetMain(),
        IONotificationPortGetRunLoopSource(port).takeUnretainedValue(),
        .defaultMode
      )
      IONotificationPortDestroy(port)
      notificationPort = nil
    }
  }

  private func handleAttached(iterator: io_iterator_t) {
    handleIterator(iterator) { device in
      guard isIosDevice(device) else { return }
      guard let serialNumber = stringProperty(device, "USB Serial Number") else { return }
      let productName = resolveFriendlyName(fallback: stringProperty(device, "USB Product Name"))

      eventSink?([
        "type": "attached",
        "id": serialNumber,
        "productName": productName as Any,
      ])
    }
  }

  private func handleDetached(iterator: io_iterator_t) {
    handleIterator(iterator) { device in
      guard let serialNumber = stringProperty(device, "USB Serial Number") else { return }

      eventSink?([
        "type": "detached",
        "id": serialNumber,
      ])
    }
  }
}
