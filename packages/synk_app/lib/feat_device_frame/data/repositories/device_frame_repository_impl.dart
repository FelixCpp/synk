import 'dart:typed_data';

import 'package:app_logger/app_logger.dart';
import 'package:clock/clock.dart';
import 'package:file/file.dart';
import 'package:path/path.dart' as path;
import 'package:synk/feat_clipboard/application/host_clipboard.dart';
import 'package:synk/feat_device_frame/application/file_picker.dart';
import 'package:synk/feat_device_frame/data/device_clipboard_sync.dart';
import 'package:synk/feat_device_frame/data/screen_capture_store.dart';
import 'package:synk/feat_device_frame/domain/models/clipboard_sync_failure.dart';
import 'package:synk/feat_device_frame/domain/models/device_frame_exception.dart';
import 'package:synk/feat_device_frame/domain/models/file_transfer_outcome.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';

class DeviceFrameRepositoryImpl({
  required final DeviceId deviceId,
  required final String modelName,
  required final DeviceSession session,
  required final SettingsRepository settingsRepository,
  required final ScreenCaptureEventChannel screenCaptureEventChannel,
  required final HostClipboard hostClipboard,
  required final FilePicker filePicker,
  required final FileSystem fileSystem,
  required final Clock clock,
}) implements DeviceFrameRepository {
  late final _clipboardSync = DeviceClipboardSync(
    deviceId: deviceId,
    hostClipboard: hostClipboard,
  );

  late final _captures = ScreenCaptureStore(
    deviceId: deviceId,
    modelName: modelName,
    settingsRepository: settingsRepository,
    events: screenCaptureEventChannel,
    fileSystem: fileSystem,
    clock: clock,
  );

  String? _runningRecordingFilepath;

  @override
  bool get isAudioMuted => session.audio?.isAudioMuted ?? true;

  @override
  Future<void> setAudioMuted(bool muted) async {
    await session.audio?.setAudioMuted(muted);
  }

  @override
  double get audioVolume => session.audio?.audioVolume ?? 1.0;

  @override
  Future<void> setAudioVolume(double volume) async {
    await session.audio?.setAudioVolume(volume);
  }

  @override
  Future<ClipboardSyncFailure?> simulateKeyEvent(DeviceKeyEvent event) async {
    final shortcut = ClipboardShortcut.of(event);
    final settings = await settingsRepository.read();

    if (shortcut == null || !settings.syncClipboard) {
      await session.interaction?.simulateKeyEvent(event);
      return null;
    }

    final clipboard = session.clipboard;
    if (event.type != .down || clipboard == null) {
      return null;
    }

    return _clipboardSync.perform(shortcut, clipboard);
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
    final screenCapture = _screenCaptureOrThrow('capture its screen');

    final pngBytes = await screenCapture.captureScreenshot();
    final filepath = await _captures.reservePath(.screenshot);
    await _captures.writeScreenshot(filepath, pngBytes);

    final settings = await settingsRepository.read();
    if (settings.copyScreenshotToClipboard) {
      await _copyToHostClipboard(pngBytes);
    }

    _captures.announceScreenshot(
      filepath: filepath,
      pngBytes: pngBytes,
      screenSize: session.screenSize,
    );
  }

  Future<void> _copyToHostClipboard(Uint8List pngBytes) async {
    try {
      await hostClipboard.writeImage(pngBytes);
    } on Object catch (error, stackTrace) {
      appLogger.w(
        'Could not put the screenshot of $deviceId on the clipboard',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> startRecording() async {
    final screenCapture = _screenCaptureOrThrow('record its screen');
    final settings = await settingsRepository.read();

    final filepath = await _captures.reservePath(.recording);
    await screenCapture.startRecording(
      filepath,
      withAudio: settings.recordAudio,
    );

    _runningRecordingFilepath = filepath;
  }

  @override
  Future<void> stopRecording() async {
    final screenCapture = session.screenCapture;
    if (screenCapture == null) {
      return;
    }

    final filepath = _runningRecordingFilepath;
    _runningRecordingFilepath = null;

    if (!await screenCapture.stopRecording()) {
      throw DeviceFrameException(
        'The recording of $deviceId holds no frames and was not written',
      );
    }

    if (filepath == null) {
      return;
    }

    _captures.announceRecording(
      filepath: filepath,
      posterBytes: await _posterFrame(screenCapture),
      screenSize: session.screenSize,
    );
  }

  Future<Uint8List?> _posterFrame(DeviceScreenCapture screenCapture) async {
    try {
      return await screenCapture.captureScreenshot();
    } on Object catch (error, stackTrace) {
      appLogger.w(
        'No poster frame for the recording of $deviceId',
        error: error,
        stackTrace: stackTrace,
      );

      return null;
    }
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
        outcomes.add((action: .installed, filename: filename));
      } else {
        await fileTransfer.pushFile(filepath);
        outcomes.add((action: .pushed, filename: filename));
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

  DeviceScreenCapture _screenCaptureOrThrow(String action) {
    final screenCapture = session.screenCapture;
    if (screenCapture == null) {
      throw DeviceFrameException('Device $deviceId cannot $action');
    }

    return screenCapture;
  }
}
