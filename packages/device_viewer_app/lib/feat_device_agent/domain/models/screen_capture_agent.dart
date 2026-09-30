import 'dart:typed_data';

import 'package:device_viewer/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:device_viewer/feat_native_texture/native_texture.dart';

abstract interface class ScreenCaptureAgent {
  NativeTextureId get textureId;
  DeviceScreenSize get screenSize;

  Future<Uint8List> captureScreenshot();
  Future<void> startRecording(String path);
  Future<bool> stopRecording();
}
