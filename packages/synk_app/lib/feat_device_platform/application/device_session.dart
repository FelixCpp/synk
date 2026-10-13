import 'dart:typed_data';

import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';

extension type const NativeTextureId(int value) implements int {}

/// One connected device. What it can do beyond being mirrored is optional.
abstract interface class DeviceSession {
  NativeTextureId get textureId;
  DeviceScreenSize get screenSize;

  /// Emits the current size first, then every change, e.g. on rotation.
  Stream<DeviceScreenSize> get screenSizeChanges;

  DeviceAudio? get audio;
  DeviceClipboard? get clipboard;
  DeviceScreenCapture? get screenCapture;
  DeviceInteraction? get interaction;
  DeviceFileTransfer? get fileTransfer;

  Future<void> dispose();
}

abstract interface class DeviceInteraction {
  Future<void> simulateKeyEvent(DeviceKeyEvent event);
  Future<void> simulatePointerEvent(DevicePointerEvent event);
  Future<void> simulatePinchEvent(PinchEvent event);

  Set<DeviceNavigation> get supportedNavigations;
  Future<void> navigate(DeviceNavigation navigation);
  Future<void> pressPowerButton();
}

abstract interface class DeviceClipboard {
  Future<void> setClipboard(String content);
  Future<String> getClipboard();
}

abstract interface class DeviceAudio {
  Future<void> setAudioMuted(bool muted);
  bool get isAudioMuted;
}

abstract interface class DeviceScreenCapture {
  Future<Uint8List> captureScreenshot();
  Future<void> startRecording(String path);
  Future<bool> stopRecording();
}

abstract interface class DeviceFileTransfer {
  Future<void> installApk(String filepath);
  Future<void> pushFile(String filepath);
}
