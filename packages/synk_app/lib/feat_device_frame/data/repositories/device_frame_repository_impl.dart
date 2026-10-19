import 'dart:typed_data';

import 'package:synk/feat_device_frame/domain/models/device_frame_exception.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';

class const DeviceFrameRepositoryImpl({
  required final DeviceId deviceId,
  required final DeviceSession session,
}) implements DeviceFrameRepository {
  @override
  DeviceScreenSize get screenSize => session.screenSize;

  @override
  DeviceClipboard? get clipboard => session.clipboard;

  @override
  bool get isAudioMuted => session.audio?.isAudioMuted ?? true;

  @override
  double get audioVolume => session.audio?.audioVolume ?? 1.0;

  @override
  Future<void> setAudioMuted(bool muted) async {
    await session.audio?.setAudioMuted(muted);
  }

  @override
  Future<void> setAudioVolume(double volume) async {
    await session.audio?.setAudioVolume(volume);
  }

  @override
  Future<void> simulateKeyEvent(DeviceKeyEvent event) async {
    await session.interaction?.simulateKeyEvent(event);
  }

  @override
  Future<void> simulatePointerEvent(DevicePointerEvent event) async {
    await session.interaction?.simulatePointerEvent(event);
  }

  @override
  Future<void> simulatePinchEvent(PinchEvent event) async {
    await session.interaction?.simulatePinchEvent(event);
  }

  @override
  Future<void> navigate(DeviceNavigation navigation) async {
    await session.interaction?.navigate(navigation);
  }

  @override
  Future<void> pressPowerButton() async {
    await session.interaction?.pressPowerButton();
  }

  @override
  Future<Uint8List> captureScreenshot() {
    return _screenCaptureOrThrow('capture its screen').captureScreenshot();
  }

  @override
  Future<void> startRecording(String filepath, {required bool withAudio}) {
    return _screenCaptureOrThrow(
      'record its screen',
    ).startRecording(filepath, withAudio: withAudio);
  }

  @override
  Future<bool> stopRecording() async {
    final screenCapture = session.screenCapture;
    return screenCapture == null ? false : screenCapture.stopRecording();
  }

  @override
  Future<void> installApk(String filepath) {
    return _fileTransferOrThrow().installApk(filepath);
  }

  @override
  Future<void> pushFile(String filepath) {
    return _fileTransferOrThrow().pushFile(filepath);
  }

  DeviceScreenCapture _screenCaptureOrThrow(String action) {
    final screenCapture = session.screenCapture;
    if (screenCapture == null) {
      throw DeviceFrameException('Device $deviceId cannot $action');
    }

    return screenCapture;
  }

  DeviceFileTransfer _fileTransferOrThrow() {
    final fileTransfer = session.fileTransfer;
    if (fileTransfer == null) {
      throw DeviceFrameException('Device $deviceId cannot receive files');
    }

    return fileTransfer;
  }
}
