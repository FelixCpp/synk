import 'dart:typed_data';

import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_mirror_session/mirror_session.dart';

abstract interface class ScreenCaptureAgent {
  NativeTextureId get textureId;
  DeviceScreenSize get screenSize;

  Future<Uint8List> captureScreenshot();
  Future<void> startRecording(String path);
  Future<bool> stopRecording();
}
