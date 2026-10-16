import AVFoundation
import Cocoa
import CoreMedia
import CoreMediaIO
import FlutterMacOS

private func allowScreenCaptureDevices() {
  var allow: UInt32 = 1
  var address = CMIOObjectPropertyAddress(
    mSelector: CMIOObjectPropertySelector(kCMIOHardwarePropertyAllowScreenCaptureDevices),
    mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
    mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMain)
  )
  CMIOObjectSetPropertyData(
    CMIOObjectID(kCMIOObjectSystemObject),
    &address,
    0,
    nil,
    UInt32(MemoryLayout<UInt32>.size),
    &allow
  )
}

@available(macOS 14.0, *)
private final class IosMirrorSession: NSObject, FlutterTexture,
  AVCaptureVideoDataOutputSampleBufferDelegate
{
  let registry: FlutterTextureRegistry
  let deviceId: String
  var textureId: Int64 = -1
  var onScreenSizeChanged: ((Int, Int) -> Void)?
  private(set) var dimensions: CMVideoDimensions?

  private let captureSession = AVCaptureSession()
  private let sampleQueue = DispatchQueue(label: "dev.synk.ios_mirror.sample_queue")
  private let sessionQueue = DispatchQueue(label: "dev.synk.ios_mirror.session_queue")

  private let bufferLock = NSLock()
  private var latestPixelBuffer: CVPixelBuffer?
  private var firstFrameHandler: ((CMVideoDimensions?) -> Void)?

  private var assetWriter: AVAssetWriter?
  private var assetWriterInput: AVAssetWriterInput?
  private var isRecordingArmed = false
  private var isRecording = false

  init(registry: FlutterTextureRegistry, deviceId: String) {
    self.registry = registry
    self.deviceId = deviceId
    super.init()
  }

  func showBlackScreen() {
    bufferLock.lock()
    let dimensions = self.dimensions
    bufferLock.unlock()
    guard let dimensions else { return }

    var buffer: CVPixelBuffer?
    CVPixelBufferCreate(
      kCFAllocatorDefault, Int(dimensions.width), Int(dimensions.height),
      kCVPixelFormatType_32BGRA, nil, &buffer
    )
    guard let buffer else { return }

    CVPixelBufferLockBaseAddress(buffer, [])
    if let base = CVPixelBufferGetBaseAddress(buffer) {
      let byteCount = CVPixelBufferGetBytesPerRow(buffer) * CVPixelBufferGetHeight(buffer)
      memset_pattern4(base, [UInt8(0), 0, 0, 255], byteCount)
    }
    CVPixelBufferUnlockBaseAddress(buffer, [])

    bufferLock.lock()
    latestPixelBuffer = buffer
    bufferLock.unlock()

    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      self.registry.textureFrameAvailable(self.textureId)
    }
  }

  func start(device: AVCaptureDevice) throws {
    captureSession.beginConfiguration()

    let input: AVCaptureDeviceInput
    do {
      input = try AVCaptureDeviceInput(device: device)
    } catch {
      captureSession.commitConfiguration()
      throw error
    }

    guard captureSession.canAddInput(input) else {
      captureSession.commitConfiguration()
      throw NSError(
        domain: "IosMirrorPlugin", code: -1,
        userInfo: [NSLocalizedDescriptionKey: "Cannot add capture input."]
      )
    }
    captureSession.addInput(input)

    let output = AVCaptureVideoDataOutput()
    output.videoSettings = [
      kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
    ]
    output.setSampleBufferDelegate(self, queue: sampleQueue)
    guard captureSession.canAddOutput(output) else {
      captureSession.commitConfiguration()
      throw NSError(
        domain: "IosMirrorPlugin", code: -2,
        userInfo: [NSLocalizedDescriptionKey: "Cannot add capture output."]
      )
    }
    captureSession.addOutput(output)

    captureSession.commitConfiguration()
    sessionQueue.async { [captureSession] in
      captureSession.startRunning()
    }
  }

  func awaitFirstFrame(timeout: TimeInterval, completion: @escaping (CMVideoDimensions?) -> Void) {
    bufferLock.lock()
    if let dimensions {
      bufferLock.unlock()
      completion(dimensions)
      return
    }
    firstFrameHandler = completion
    bufferLock.unlock()

    DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { [weak self] in
      guard let self else { return }
      self.bufferLock.lock()
      let handler = self.firstFrameHandler
      self.firstFrameHandler = nil
      self.bufferLock.unlock()
      handler?(nil)
    }
  }

  func stop() {
    captureSession.stopRunning()
    for input in captureSession.inputs { captureSession.removeInput(input) }
    for output in captureSession.outputs { captureSession.removeOutput(output) }

    bufferLock.lock()
    latestPixelBuffer = nil
    bufferLock.unlock()

    if isRecording || isRecordingArmed {
      assetWriterInput?.markAsFinished()
      assetWriter?.cancelWriting()
    }
    assetWriter = nil
    assetWriterInput = nil
    isRecordingArmed = false
    isRecording = false
  }

  func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
    bufferLock.lock()
    defer { bufferLock.unlock() }
    guard let buffer = latestPixelBuffer else { return nil }
    return Unmanaged.passRetained(buffer)
  }

  func captureOutput(
    _ output: AVCaptureOutput,
    didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

    let frameDimensions = CMVideoDimensions(
      width: Int32(CVPixelBufferGetWidth(pixelBuffer)),
      height: Int32(CVPixelBufferGetHeight(pixelBuffer))
    )

    bufferLock.lock()
    latestPixelBuffer = pixelBuffer
    var resolvedHandler: ((CMVideoDimensions?) -> Void)?
    let didChangeDimensions =
      dimensions?.width != frameDimensions.width
      || dimensions?.height != frameDimensions.height
    if didChangeDimensions {
      dimensions = frameDimensions
      resolvedHandler = firstFrameHandler
      firstFrameHandler = nil
    }
    bufferLock.unlock()

    if didChangeDimensions {
      DispatchQueue.main.async { [weak self] in
        resolvedHandler?(frameDimensions)
        self?.onScreenSizeChanged?(Int(frameDimensions.width), Int(frameDimensions.height))
      }
    }

    appendToRecording(
      sampleBuffer: sampleBuffer,
      presentationTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
    )

    DispatchQueue.main.async { [weak self] in
      guard let self else { return }
      self.registry.textureFrameAvailable(self.textureId)
    }
  }

  func startRecording(path: String) throws {
    guard !isRecording, !isRecordingArmed else { return }
    guard let dimensions else {
      throw NSError(
        domain: "IosMirrorPlugin", code: -3,
        userInfo: [NSLocalizedDescriptionKey: "Capture dimensions not yet known."]
      )
    }

    let url = URL(fileURLWithPath: path)
    try? FileManager.default.removeItem(at: url)

    let writer = try AVAssetWriter(outputURL: url, fileType: .mp4)
    let outputSettings: [String: Any] = [
      AVVideoCodecKey: AVVideoCodecType.h264,
      AVVideoWidthKey: Int(dimensions.width),
      AVVideoHeightKey: Int(dimensions.height),
    ]
    let input = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings)
    input.expectsMediaDataInRealTime = true

    guard writer.canAdd(input) else {
      throw NSError(
        domain: "IosMirrorPlugin", code: -4,
        userInfo: [NSLocalizedDescriptionKey: "Recorder cannot accept the incoming video stream."]
      )
    }
    writer.add(input)
    writer.startWriting()

    assetWriter = writer
    assetWriterInput = input
    isRecordingArmed = true
  }

  func stopRecording(completion: @escaping (Bool) -> Void) {
    guard let writer = assetWriter, isRecording || isRecordingArmed else {
      completion(false)
      return
    }

    isRecording = false
    isRecordingArmed = false
    assetWriterInput?.markAsFinished()
    writer.finishWriting {
      completion(writer.status == .completed)
    }
    assetWriter = nil
    assetWriterInput = nil
  }

  private func appendToRecording(sampleBuffer: CMSampleBuffer, presentationTime: CMTime) {
    guard isRecording || isRecordingArmed else { return }

    if isRecordingArmed {
      assetWriter?.startSession(atSourceTime: presentationTime)
      isRecordingArmed = false
      isRecording = true
    }

    guard isRecording, let input = assetWriterInput, input.isReadyForMoreMediaData else { return }
    input.append(sampleBuffer)
  }

  func captureScreenshot() -> Data? {
    bufferLock.lock()
    let buffer = latestPixelBuffer
    bufferLock.unlock()
    guard let buffer else { return nil }

    let ciImage = CIImage(cvPixelBuffer: buffer)
    let context = CIContext()
    guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }

    let rep = NSBitmapImageRep(cgImage: cgImage)
    return rep.representation(using: .png, properties: [:])
  }
}

@available(macOS 14.0, *)
public class IosMirrorPlugin: NSObject, FlutterPlugin {
  private let registry: FlutterTextureRegistry
  private let screenSizeStream = IosScreenSizeStreamHandler()

  private let sessionsLock = NSLock()
  private var sessions: [Int64: IosMirrorSession] = [:]

  public static func register(with registrar: FlutterPluginRegistrar) {
    allowScreenCaptureDevices()

    let channel = FlutterMethodChannel(
      name: "dev.synk/ios_mirror",
      binaryMessenger: registrar.messenger
    )
    let instance = IosMirrorPlugin(registry: registrar.textures)
    registrar.addMethodCallDelegate(instance, channel: channel)

    FlutterEventChannel(
      name: "dev.synk/ios_mirror/screen_size",
      binaryMessenger: registrar.messenger
    ).setStreamHandler(instance.screenSizeStream)
  }

  init(registry: FlutterTextureRegistry) {
    self.registry = registry
    super.init()

    NotificationCenter.default.addObserver(
      forName: .iosScreenWentDark, object: nil, queue: nil
    ) { [weak self] notification in
      guard let self, let udid = notification.userInfo?["udid"] as? String else { return }
      self.sessionsLock.lock()
      let matching = self.sessions.values.filter { $0.deviceId == udid }
      self.sessionsLock.unlock()
      for session in matching { session.showBlackScreen() }
    }
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "startMirror":
      guard let args = call.arguments as? [String: Any],
        let deviceId = args["deviceId"] as? String
      else {
        result(FlutterError(code: "invalid_args", message: "deviceId is required", details: nil))
        return
      }
      startMirror(deviceId: deviceId, result: result)
    case "stopMirror":
      guard let textureId = textureId(from: call) else {
        result(FlutterError(code: "invalid_args", message: "textureId is required", details: nil))
        return
      }
      destroySession(textureId)
      result(nil)
    case "captureScreenshot":
      guard let textureId = textureId(from: call), let session = session(for: textureId) else {
        result(FlutterError(code: "invalid_args", message: "textureId is required", details: nil))
        return
      }
      guard let pngData = session.captureScreenshot() else {
        result(
          FlutterError(code: "screenshot_failed", message: "No frame available yet.", details: nil))
        return
      }
      result(FlutterStandardTypedData(bytes: pngData))
    case "startRecording":
      guard let textureId = textureId(from: call), let session = session(for: textureId) else {
        result(FlutterError(code: "invalid_args", message: "textureId is required", details: nil))
        return
      }
      guard let args = call.arguments as? [String: Any], let path = args["path"] as? String else {
        result(FlutterError(code: "invalid_args", message: "path is required", details: nil))
        return
      }
      do {
        try session.startRecording(path: path)
        result(nil)
      } catch {
        result(FlutterError(code: "recording_failed", message: error.localizedDescription, details: nil))
      }
    case "stopRecording":
      guard let textureId = textureId(from: call), let session = session(for: textureId) else {
        result(FlutterError(code: "invalid_args", message: "textureId is required", details: nil))
        return
      }
      session.stopRecording { success in
        result(success)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func startMirror(deviceId: String, result: @escaping FlutterResult) {
    guard let device = matchCaptureDevice(serialNumber: deviceId) else {
      result(
        FlutterError(
          code: "device_not_found", message: "No capture device found for \(deviceId)", details: nil
        ))
      return
    }

    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      startMirrorSession(deviceId: deviceId, device: device, result: result)
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
        DispatchQueue.main.async {
          guard granted else {
            result(Self.cameraAccessDeniedError())
            return
          }
          self?.startMirrorSession(deviceId: deviceId, device: device, result: result)
        }
      }
    default:
      result(Self.cameraAccessDeniedError())
    }
  }

  private static func cameraAccessDeniedError() -> FlutterError {
    FlutterError(
      code: "camera_access_denied",
      message:
        "Camera access is required to mirror iOS devices. "
        + "Allow synk under System Settings > Privacy & Security > Camera.",
      details: nil
    )
  }

  private func startMirrorSession(
    deviceId: String, device: AVCaptureDevice, result: @escaping FlutterResult
  ) {
    let session = IosMirrorSession(registry: registry, deviceId: deviceId)
    do {
      try session.start(device: device)
    } catch {
      result(FlutterError(code: "start_failed", message: error.localizedDescription, details: nil))
      return
    }

    let textureId = registry.register(session)
    session.textureId = textureId
    session.onScreenSizeChanged = { [weak self] width, height in
      self?.screenSizeStream.send(textureId: textureId, width: width, height: height)
    }

    sessionsLock.lock()
    sessions[textureId] = session
    sessionsLock.unlock()

    session.awaitFirstFrame(timeout: 5.0) { [weak self] dimensions in
      guard let dimensions else {
        self?.destroySession(textureId)
        result(
          FlutterError(
            code: "no_frame", message: "Timed out waiting for the first mirrored frame.",
            details: nil
          ))
        return
      }

      result([
        "textureId": textureId,
        "width": Int(dimensions.width),
        "height": Int(dimensions.height),
      ])
    }
  }

  private func matchCaptureDevice(serialNumber: String) -> AVCaptureDevice? {
    let discovery = AVCaptureDevice.DiscoverySession(
      deviceTypes: [.external],
      mediaType: .muxed,
      position: .unspecified
    )

    if discovery.devices.count <= 1 {
      return discovery.devices.first
    }

    return discovery.devices.first { $0.uniqueID.contains(serialNumber) }
      ?? discovery.devices.first { $0.localizedName.contains(serialNumber) }
  }

  private func textureId(from call: FlutterMethodCall) -> Int64? {
    guard let args = call.arguments as? [String: Any] else { return nil }
    return (args["textureId"] as? NSNumber)?.int64Value
  }

  private func session(for textureId: Int64) -> IosMirrorSession? {
    sessionsLock.lock()
    defer { sessionsLock.unlock() }
    return sessions[textureId]
  }

  private func destroySession(_ textureId: Int64) {
    sessionsLock.lock()
    let session = sessions.removeValue(forKey: textureId)
    sessionsLock.unlock()

    session?.onScreenSizeChanged = nil
    session?.stop()
    registry.unregisterTexture(textureId)
  }
}

private final class IosScreenSizeStreamHandler: NSObject, FlutterStreamHandler {
  private var sink: FlutterEventSink?

  func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
    sink = eventSink
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    sink = nil
    return nil
  }

  func send(textureId: Int64, width: Int, height: Int) {
    DispatchQueue.main.async { [weak self] in
      self?.sink?([
        "textureId": textureId,
        "width": width,
        "height": height,
      ])
    }
  }
}
