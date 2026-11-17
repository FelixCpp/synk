import FlutterMacOS
import Foundation
import dnssd

private struct ResolvedService {
  let hostTarget: String
  let port: Int
  let txt: [String: String]
}

private func parseTxtRecord(length: UInt16, bytes: UnsafePointer<UInt8>?) -> [String: String] {
  guard let bytes else { return [:] }

  var entries: [String: String] = [:]
  let count = TXTRecordGetCount(length, bytes)
  for index in 0..<count {
    var key = [CChar](repeating: 0, count: 256)
    var valueLength: UInt8 = 0
    var value: UnsafeRawPointer?
    let error = TXTRecordGetItemAtIndex(length, bytes, index, 256, &key, &valueLength, &value)
    guard error == kDNSServiceErr_NoError else { continue }

    let data = value.map { Data(bytes: $0, count: Int(valueLength)) } ?? Data()
    entries[String(cString: key)] = String(data: data, encoding: .utf8) ?? ""
  }

  return entries
}

private final class DnssdQuery<Value> {
  private var serviceRef: DNSServiceRef?
  private var completion: ((Value?) -> Void)?

  init(completion: @escaping (Value?) -> Void) {
    self.completion = completion
  }

  func start(
    timeout: TimeInterval,
    _ open: (inout DNSServiceRef?, UnsafeMutableRawPointer) -> DNSServiceErrorType
  ) {
    let context = Unmanaged.passRetained(self).toOpaque()

    guard open(&serviceRef, context) == kDNSServiceErr_NoError, let serviceRef else {
      finish(nil)
      return
    }

    DNSServiceSetDispatchQueue(serviceRef, .main)
    DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { self.finish(nil) }
  }

  func finish(_ value: Value?) {
    guard let completion else { return }
    self.completion = nil

    if let serviceRef {
      DNSServiceRefDeallocate(serviceRef)
      self.serviceRef = nil
    }

    completion(value)
    Unmanaged.passUnretained(self).release()
  }

  static func from(_ context: UnsafeMutableRawPointer?) -> DnssdQuery<Value>? {
    context.map { Unmanaged<DnssdQuery<Value>>.fromOpaque($0).takeUnretainedValue() }
  }
}

private func resolveService(
  name: String,
  type: String,
  timeout: TimeInterval,
  completion: @escaping (ResolvedService?) -> Void
) {
  DnssdQuery<ResolvedService>(completion: completion).start(timeout: timeout) { ref, context in
    DNSServiceResolve(
      &ref, 0, 0, name, type, "local.",
      { _, _, _, errorCode, _, hostTarget, port, txtLength, txtRecord, context in
        guard let query = DnssdQuery<ResolvedService>.from(context) else { return }
        guard errorCode == kDNSServiceErr_NoError, let hostTarget else {
          query.finish(nil)
          return
        }

        query.finish(
          ResolvedService(
            hostTarget: String(cString: hostTarget),
            port: Int(UInt16(bigEndian: port)),
            txt: parseTxtRecord(length: txtLength, bytes: txtRecord)
          )
        )
      },
      context
    )
  }
}

private func lookupIpv4Address(
  hostName: String,
  timeout: TimeInterval,
  completion: @escaping (String?) -> Void
) {
  DnssdQuery<String>(completion: completion).start(timeout: timeout) { ref, context in
    DNSServiceGetAddrInfo(
      &ref, 0, 0, DNSServiceProtocol(kDNSServiceProtocol_IPv4), hostName,
      { _, _, _, errorCode, _, address, _, context in
        guard let query = DnssdQuery<String>.from(context) else { return }
        guard errorCode == kDNSServiceErr_NoError, let address,
          address.pointee.sa_family == sa_family_t(AF_INET)
        else {
          query.finish(nil)
          return
        }

        var ipv4 = address.withMemoryRebound(to: sockaddr_in.self, capacity: 1) {
          $0.pointee.sin_addr
        }
        var buffer = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
        inet_ntop(AF_INET, &ipv4, &buffer, socklen_t(INET_ADDRSTRLEN))
        query.finish(String(cString: buffer))
      },
      context
    )
  }
}

private final class ServiceBrowser: NSObject, FlutterStreamHandler {
  private var browseRef: DNSServiceRef?
  private var type = ""
  private var sightings: [String: Int] = [:]
  private var services: [String: [String: Any]] = [:]
  private var eventSink: FlutterEventSink?

  func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink)
    -> FlutterError?
  {
    guard let type = arguments as? String else {
      return FlutterError(code: "badArguments", message: nil, details: nil)
    }

    self.type = type
    self.eventSink = eventSink
    emit()

    let context = Unmanaged.passUnretained(self).toOpaque()
    let error = DNSServiceBrowse(
      &browseRef, 0, 0, type, "local.",
      { _, flags, _, errorCode, name, _, _, context in
        guard errorCode == kDNSServiceErr_NoError, let name, let context else { return }
        let browser = Unmanaged<ServiceBrowser>.fromOpaque(context).takeUnretainedValue()
        browser.handle(
          name: String(cString: name),
          isAdded: flags & DNSServiceFlags(kDNSServiceFlagsAdd) != 0
        )
      },
      context
    )

    guard error == kDNSServiceErr_NoError, let browseRef else {
      return FlutterError(code: "browseFailed", message: "DNSServiceBrowse \(error)", details: nil)
    }

    DNSServiceSetDispatchQueue(browseRef, .main)
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    if let browseRef {
      DNSServiceRefDeallocate(browseRef)
      self.browseRef = nil
    }
    sightings = [:]
    services = [:]
    eventSink = nil
    return nil
  }

  private func handle(name: String, isAdded: Bool) {
    let count = (sightings[name] ?? 0) + (isAdded ? 1 : -1)

    guard count > 0 else {
      sightings.removeValue(forKey: name)
      services.removeValue(forKey: name)
      emit()
      return
    }

    sightings[name] = count
    guard isAdded else { return }

    let type = self.type
    resolveService(name: name, type: type, timeout: 5) { [weak self] resolved in
      guard let resolved else { return }

      lookupIpv4Address(hostName: resolved.hostTarget, timeout: 5) { address in
        guard let self, let address, self.type == type, self.sightings[name] != nil else {
          return
        }

        self.services[name] = ["name": name, "host": address, "port": resolved.port]
        self.emit()
      }
    }
  }

  private func emit() {
    eventSink?(services.keys.sorted().compactMap { services[$0] })
  }
}

public class BonjourResolverPlugin: NSObject, FlutterPlugin {
  private static var browser: ServiceBrowser?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "dev.synk/bonjour",
      binaryMessenger: registrar.messenger
    )
    registrar.addMethodCallDelegate(BonjourResolverPlugin(), channel: channel)

    let browser = ServiceBrowser()
    FlutterEventChannel(name: "dev.synk/bonjour_browse", binaryMessenger: registrar.messenger)
      .setStreamHandler(browser)
    self.browser = browser
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "resolve":
      guard
        let arguments = call.arguments as? [String: Any],
        let name = arguments["name"] as? String,
        let type = arguments["type"] as? String,
        let timeoutMs = arguments["timeoutMs"] as? Int
      else {
        result(FlutterError(code: "badArguments", message: nil, details: nil))
        return
      }

      resolveService(name: name, type: type, timeout: TimeInterval(timeoutMs) / 1000) {
        resolved in
        result(resolved.map { ["port": $0.port, "txt": $0.txt] })
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
