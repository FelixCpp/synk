import 'dart:io';

import 'package:api_devicectl/api_devicectl.dart';
import 'package:app_logger/app_logger.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_frame/domain/models/clipboard_sync_failure.dart';
import 'package:synk/feat_device_frame/domain/models/dropped_file_outcome.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';

class const DeviceFrameRepository({
  required final DeviceId deviceId,
  required final String modelName,
  required final DeviceSession session,
  required final SettingsRepository settingsRepository,
  required final ScreenCaptureEventChannel screenCaptureEventChannel,
}) {
  Future<ClipboardSyncFailure?> simulateKeyEvent(DeviceKeyEvent event) async {
    final shortcut = _clipboardShortcutOf(event);

    if (shortcut == null || !await settingsRepository.getSyncClipboard()) {
      await session.interaction?.simulateKeyEvent(event);
      return null;
    }

    if (event.type != .down) {
      return null;
    }

    final clipboard = session.clipboard;
    if (clipboard == null) {
      return null;
    }

    return switch (shortcut) {
      .copyFromDevice => _copyFromDevice(clipboard),
      .pasteToDevice => _pasteToDevice(clipboard),
    };
  }

  Future<ClipboardSyncFailure?> _copyFromDevice(
    DeviceClipboard clipboard,
  ) async {
    final String text;
    try {
      text = await clipboard.getClipboard();
    } on Object catch (error, stackTrace) {
      return _unreachableClipboard(error, stackTrace);
    }

    if (text.isEmpty) {
      return null;
    }

    await Clipboard.setData(ClipboardData(text: text));
    return null;
  }

  Future<ClipboardSyncFailure?> _pasteToDevice(
    DeviceClipboard clipboard,
  ) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if (text == null) {
      return null;
    }

    try {
      await clipboard.setClipboard(text);
      return null;
    } on Object catch (error, stackTrace) {
      return _unreachableClipboard(error, stackTrace);
    }
  }

  ClipboardSyncFailure _unreachableClipboard(
    Object error,
    StackTrace stackTrace,
  ) {
    appLogger.w(
      'No clipboard sync for $deviceId; swallowing the shortcut',
      error: error,
      stackTrace: stackTrace,
    );

    return switch (error) {
      DevicectlCommandException() || ProcessException() => .toolUnavailable,
      _ => .deviceUnreachable,
    };
  }

  Future<void> simulatePointerEvent(DevicePointerEvent event) async {
    await session.interaction?.simulatePointerEvent(event);
  }

  Future<void> simulatePinchEvent(PinchEvent event) async {
    await session.interaction?.simulatePinchEvent(event);
  }

  Future<void> navigate(DeviceNavigation navigation) async {
    await session.interaction?.navigate(navigation);
  }

  Future<void> pressPowerButton() async {
    await session.interaction?.pressPowerButton();
  }

  Future<void> captureScreenshot() async {
    final screenCapture = session.screenCapture;
    if (screenCapture == null) {
      // TODO(Felix): Custom exception type
      throw Exception('Device $deviceId cannot capture its screen');
    }

    final pngBytes = await screenCapture.captureScreenshot();
    final filepath = await _screenCaptureFilepath('Screenshot', 'png');
    await File(filepath).writeAsBytes(pngBytes);

    screenCaptureEventChannel.submit(
      .png(
        bytes: pngBytes,
        filepath: filepath,
        screenSize: session.screenSize,
        deviceId: deviceId,
        modelName: modelName,
      ),
    );
  }

  Future<void> startRecording() async {
    final screenCapture = session.screenCapture;
    if (screenCapture == null) {
      // TODO(Felix): Custom exception type
      throw Exception('Device $deviceId cannot record its screen');
    }

    final filepath = await _screenCaptureFilepath('Recording', 'mp4');
    await screenCapture.startRecording(filepath);
  }

  Future<String> _screenCaptureFilepath(String kind, String extension) async {
    final directory = await settingsRepository.getScreenCaptureSavePath();
    await Directory(directory).create(recursive: true);

    final timestamp = DateFormat("yyyy-MM-dd 'at' HH.mm.ss").format(
      DateTime.now(),
    );

    return path.join(directory, '$kind $modelName $timestamp.$extension');
  }

  Future<void> stopRecording() async {
    final screenCapture = session.screenCapture;
    if (screenCapture == null) {
      return;
    }

    if (!await screenCapture.stopRecording()) {
      // TODO(Felix): Custom exception type
      throw Exception(
        'The recording of $deviceId holds no frames and was not written',
      );
    }
  }

  /// Applies the user's connect-time audio preference, reporting what stuck.
  Future<bool> applyAudioMutePreference() async {
    final muted = await settingsRepository.getMuteOnConnect();
    await setAudioMuted(muted);
    return session.audio?.isAudioMuted ?? true;
  }

  Future<void> setAudioMuted(bool muted) async {
    await session.audio?.setAudioMuted(muted);
  }

  Future<List<DroppedFileOutcome>> handleDroppedFiles(
    List<String> filepaths,
  ) async {
    final fileTransfer = session.fileTransfer;
    if (fileTransfer == null) {
      // TODO(Felix): Custom exception type
      throw Exception('Device $deviceId cannot receive files');
    }

    final outcomes = <DroppedFileOutcome>[];

    for (final filepath in filepaths) {
      final filename = path.basename(filepath);
      final isApk = path.extension(filepath).toLowerCase() == '.apk';

      if (isApk) {
        await fileTransfer.installApk(filepath);
        outcomes.add((action: .installed, filename: filename));
      } else {
        await fileTransfer.pushFile(filepath);
        outcomes.add((action: .pushed, filename: filename));
      }
    }

    return outcomes;
  }

  Future<DroppedFileOutcome?> installApk() async {
    const apkGroup = XTypeGroup(label: 'APKs', extensions: ['apk']);

    final file = await openFile(acceptedTypeGroups: const [apkGroup]);
    if (file == null) {
      return null;
    }

    final outcomes = await handleDroppedFiles([file.path]);
    return outcomes.isEmpty ? null : outcomes.first;
  }

  Future<DroppedFileOutcome?> shareFile() async {
    final file = await openFile();
    if (file == null) {
      return null;
    }

    final outcomes = await handleDroppedFiles([file.path]);
    return outcomes.isEmpty ? null : outcomes.first;
  }
}

enum _ClipboardShortcut {
  copyFromDevice,
  pasteToDevice,
}

_ClipboardShortcut? _clipboardShortcutOf(DeviceKeyEvent event) {
  if (!event.isMetaPressed) {
    return null;
  }

  return switch (event.key) {
    LogicalKeyboardKey.keyC => .copyFromDevice,
    LogicalKeyboardKey.keyV => .pasteToDevice,
    _ => null,
  };
}
