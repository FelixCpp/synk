import 'dart:typed_data';

import 'package:app_logger/app_logger.dart';
import 'package:path/path.dart' as path;
import 'package:synk/feat_clipboard/domain/clipboard_feature.dart';
import 'package:synk/feat_device_frame/application/file_picker.dart';
import 'package:synk/feat_device_frame/data/screen_capture_store.dart';
import 'package:synk/feat_device_frame/domain/device_clipboard_sync.dart';
import 'package:synk/feat_device_frame/domain/device_frame_feature.dart';
import 'package:synk/feat_device_frame/domain/models/device_frame_exception.dart';
import 'package:synk/feat_device_frame/domain/models/file_transfer_outcome.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_kind.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';

class DeviceFrameFeatureImpl({
  required final DeviceId deviceId,
  required final DeviceSession session,
  required final ScreenCaptureStore captures,
  required final SettingsRepository settingsRepository,
  required final ClipboardFeature clipboard,
  required final FilePicker filePicker,
}) implements DeviceFrameFeature {
  final _clipboardSync = DeviceClipboardSync(clipboard);

  String? _runningRecording;

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
    final shortcut = ClipboardShortcut.of(event);
    final deviceClipboard = session.clipboard;

    if (shortcut == null || deviceClipboard == null) {
      await session.interaction?.simulateKeyEvent(event);
      return;
    }

    final settings = await settingsRepository.read();
    if (!settings.syncClipboard) {
      await session.interaction?.simulateKeyEvent(event);
      return;
    }

    if (event.type != DeviceKeyEventType.down) {
      return;
    }

    await _clipboardSync.perform(shortcut, deviceClipboard);
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
  Future<void> captureScreenshot() async {
    final pngBytes = await _screenCaptureOrThrow(
      'capture its screen',
    ).captureScreenshot();

    final filepath = await captures.reservePath(ScreenCaptureKind.screenshot);
    await captures.writeScreenshot(filepath, pngBytes);

    final settings = await settingsRepository.read();
    if (settings.copyScreenshotToClipboard) {
      await _putOnClipboard(pngBytes);
    }

    captures.announceScreenshot(
      filepath: filepath,
      pngBytes: pngBytes,
      screenSize: session.screenSize,
    );
  }

  @override
  Future<void> startRecording() async {
    final screenCapture = _screenCaptureOrThrow('record its screen');
    final settings = await settingsRepository.read();
    final filepath = await captures.reservePath(ScreenCaptureKind.recording);

    await screenCapture.startRecording(
      filepath,
      withAudio: settings.recordAudio,
    );

    _runningRecording = filepath;
  }

  @override
  Future<void> stopRecording() async {
    final screenCapture = session.screenCapture;
    if (screenCapture == null) {
      return;
    }

    final filepath = _runningRecording;
    _runningRecording = null;

    if (!await screenCapture.stopRecording()) {
      throw const DeviceFrameException(
        'Die Aufnahme enthielt kein Bild und wurde nicht gespeichert.',
      );
    }

    if (filepath == null) {
      return;
    }

    captures.announceRecording(
      filepath: filepath,
      posterBytes: await _posterFrame(screenCapture),
      screenSize: session.screenSize,
    );
  }

  @override
  Future<List<FileTransferOutcome>> sendFiles(List<String> filepaths) async {
    final fileTransfer = session.fileTransfer;
    if (fileTransfer == null) {
      throw DeviceFrameException('Device $deviceId cannot receive files');
    }

    final outcomes = <FileTransferOutcome>[];

    for (final filepath in filepaths) {
      final filename = path.basename(filepath);

      if (path.extension(filepath).toLowerCase() == '.apk') {
        await fileTransfer.installApk(filepath);
        outcomes.add((
          action: FileTransferAction.installed,
          filename: filename,
        ));
      } else {
        await fileTransfer.pushFile(filepath);
        outcomes.add((action: FileTransferAction.pushed, filename: filename));
      }
    }

    return outcomes;
  }

  @override
  Future<FileTransferOutcome?> sendPickedApk() {
    return _sendPicked(filePicker.pickApk);
  }

  @override
  Future<FileTransferOutcome?> sendPickedFile() {
    return _sendPicked(filePicker.pickAnyFile);
  }

  Future<FileTransferOutcome?> _sendPicked(
    Future<String?> Function() pick,
  ) async {
    final filepath = await pick();
    if (filepath == null) {
      return null;
    }

    final outcomes = await sendFiles([filepath]);
    return outcomes.isEmpty ? null : outcomes.first;
  }

  Future<void> _putOnClipboard(Uint8List pngBytes) async {
    try {
      await clipboard.writeImage(pngBytes);
    } on Object catch (error, stackTrace) {
      appLogger.w(
        'The screenshot is saved but did not make it onto the clipboard',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<Uint8List?> _posterFrame(DeviceScreenCapture screenCapture) async {
    try {
      return await screenCapture.captureScreenshot();
    } on Object catch (error, stackTrace) {
      appLogger.w(
        'The recording is saved but has no poster frame',
        error: error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  DeviceScreenCapture _screenCaptureOrThrow(String action) {
    final screenCapture = session.screenCapture;
    if (screenCapture == null) {
      throw DeviceFrameException('Device $deviceId cannot $action');
    }

    return screenCapture;
  }
}
