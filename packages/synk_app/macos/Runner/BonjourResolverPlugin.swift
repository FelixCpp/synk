import FlutterMacOS
import Foundation
import dnssd

private final class PortResolution {
  private var serviceRef: DNSServiceRef?
  private var completion: ((Int?) -> Void)?

  init(completion: @escaping (Int?) -> Void) {
    self.completion = completion
  }

  func start(name: String, type: String, timeout: TimeInterval) {
    let context = Unmanaged.passRetained(self).toOpaque()

    let error = DNSServiceResolve(
      &serviceRef,
      0,
      0,
      name,
      type,
      "local.",
      { _, _, _, errorCode, _, _, port, _, _, context in
        guard let context else { return }
        let resolution = Unmanaged<PortResolution>.fromOpaque(context).takeUnretainedValue()
        resolution.finish(errorCode == kDNSServiceErr_NoError ? Int(UInt16(bigEndian: port)) : nil)
      },
      context
    )

    guard error == kDNSServiceErr_NoError, let serviceRef else {
      finish(nil)
      return
    }

    DNSServiceSetDispatchQueue(serviceRef, .main)
    DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { self.finish(nil) }
  }

  private func finish(_ port: Int?) {
    guard let completion else { return }
    self.completion = nil

    if let serviceRef {
      DNSServiceRefDeallocate(serviceRef)
      self.serviceRef = nil
    }

    completion(port)
    Unmanaged.passUnretained(self).release()
  }
}

public class BonjourResolverPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "dev.synk/bonjour",
      binaryMessenger: registrar.messenger
    )
    registrar.addMethodCallDelegate(BonjourResolverPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "resolvePort":
      guard
        let arguments = call.arguments as? [String: Any],
        let name = arguments["name"] as? String,
        let type = arguments["type"] as? String,
        let timeoutMs = arguments["timeoutMs"] as? Int
      else {
        result(FlutterError(code: "badArguments", message: nil, details: nil))
        return
      }

      PortResolution { port in result(port) }
        .start(name: name, type: type, timeout: TimeInterval(timeoutMs) / 1000)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
