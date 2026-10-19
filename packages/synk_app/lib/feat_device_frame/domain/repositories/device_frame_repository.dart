import 'dart:typed_data';

import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';

/// One connected device, as far as a frame can drive it.
///
/// Delegation only — what Synk decides to do with a device lives in the
/// interactors.
abstract interface class DeviceFrameRepository {
  DeviceScreenSize get screenSize;
  DeviceClipboard? get clipboard;

  bool get isAudioMuted;
  double get audioVolume;
  Future<void> setAudioMuted(bool muted);
  Future<void> setAudioVolume(double volume);

  Future<void> simulateKeyEvent(DeviceKeyEvent event);
  Future<void> simulatePointerEvent(DevicePointerEvent event);
  Future<void> simulatePinchEvent(PinchEvent event);
  Future<void> navigate(DeviceNavigation navigation);
  Future<void> pressPowerButton();

  Future<Uint8List> captureScreenshot();
  Future<void> startRecording(String filepath, {required bool withAudio});
  Future<bool> stopRecording();

  Future<void> installApk(String filepath);
  Future<void> pushFile(String filepath);
}
