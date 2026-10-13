import 'dart:typed_data';

abstract interface class ScreenCaptureDeviceAgent {
  Future<Uint8List> captureScreenshot();
  Future<void> startRecording(String path);
  Future<bool> stopRecording();
}
