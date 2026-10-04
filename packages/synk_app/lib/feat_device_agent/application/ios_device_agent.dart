import 'dart:typed_data';

import 'package:synk/feat_device_agent/data/datasources/ios_mirror_channel.dart';
import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_agent/domain/models/screen_capture_agent.dart';
import 'package:synk/feat_native_texture/native_texture.dart';

class IosDeviceAgent(
  final IosMirrorChannel channel,
  @override final NativeTextureId textureId,
  @override final DeviceScreenSize screenSize,
) implements ScreenCaptureAgent {
  @override
  Future<Uint8List> captureScreenshot() {
    return channel.captureScreenshot(textureId);
  }

  @override
  Future<void> startRecording(String path) {
    return channel.startRecording(textureId, path);
  }

  @override
  Future<bool> stopRecording() {
    return channel.stopRecording(textureId);
  }

  Future<void> dispose() {
    return channel.stopMirror(textureId);
  }
}
