import 'dart:io';

import 'package:api_devicectl/api_devicectl.dart';
import 'package:app_logger/app_logger.dart';
import 'package:synk/feat_device_platform/application/agents/clipboard_device_agent.dart';
import 'package:synk/feat_device_platform/domain/models/device_key_event.dart';
import 'package:synk/feat_device_platform/domain/models/device_pointer_event.dart';
import 'package:synk/feat_device_platform/domain/models/device_navigation.dart';
import 'package:synk/feat_device_platform/domain/models/pinch_event.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_frame/domain/models/clipboard_sync_failure.dart';
import 'package:synk/feat_device_frame/domain/models/dropped_file_outcome.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

class const DeviceFrameRepository({
  required final DeviceConnectionsRepository repository,
}) {
  Future<ClipboardSyncFailure?> simulateKeyEvent(
    DeviceId deviceId,
    DeviceKeyEvent event,
  ) async {
    final shortcut = _clipboardShortcutOf(event);

    if (shortcut == null) {
      await repository.getAgent(deviceId)?.interaction?.simulateKeyEvent(event);
      return null;
    }

    if (event.type != .down) {
      return null;
    }

    final agent = repository.getAgent(deviceId)?.clipboard;
    if (agent == null) {
      return null;
    }

    return switch (shortcut) {
      .copyFromDevice => _copyFromDevice(deviceId, agent),
      .pasteToDevice => _pasteToDevice(deviceId, agent),
    };
  }

  Future<ClipboardSyncFailure?> _copyFromDevice(
    DeviceId deviceId,
    ClipboardDeviceAgent agent,
  ) async {
    final String text;
    try {
      text = await agent.getClipboard();
    } on Object catch (error, stackTrace) {
      return _unreachableClipboard(deviceId, error, stackTrace);
    }

    if (text.isEmpty) {
      return null;
    }

    await Clipboard.setData(ClipboardData(text: text));
    return null;
  }

  Future<ClipboardSyncFailure?> _pasteToDevice(
    DeviceId deviceId,
    ClipboardDeviceAgent agent,
  ) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if (text == null) {
      return null;
    }

    try {
      await agent.setClipboard(text);
      return null;
    } on Object catch (error, stackTrace) {
      return _unreachableClipboard(deviceId, error, stackTrace);
    }
  }

  ClipboardSyncFailure _unreachableClipboard(
    DeviceId deviceId,
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

  Future<void> simulatePointerEvent(
    DeviceId deviceId,
    DevicePointerEvent event,
  ) async {
    await repository
        .getAgent(deviceId)
        ?.interaction
        ?.simulatePointerEvent(event);
  }

  Future<void> simulatePinchEvent(DeviceId deviceId, PinchEvent event) async {
    await repository.getAgent(deviceId)?.interaction?.simulatePinchEvent(event);
  }

  Future<void> navigate(DeviceId deviceId, DeviceNavigation navigation) async {
    await repository.getAgent(deviceId)?.interaction?.navigate(navigation);
  }

  Future<void> pressPowerButton(DeviceId deviceId) async {
    await repository.getAgent(deviceId)?.interaction?.pressPowerButton();
  }

  Future<void> captureScreenshot(DeviceId deviceId) async {
    const pngGroup = XTypeGroup(
      label: 'PNGs',
      extensions: ['png'],
      uniformTypeIdentifiers: ['public.png'],
    );

    final agent = repository.getAgent(deviceId)?.screenCapture;
    if (agent == null) {
      // TODO(Felix): Custom exception type
      throw Exception('Could not resolve agent for device $deviceId');
    }

    final pngBytes = await agent.captureScreenshot();
    final filename = 'screenshot_$deviceId.png';
    final saveLocation = await getSaveLocation(
      acceptedTypeGroups: const [pngGroup],
      suggestedName: filename,
    );

    if (saveLocation == null) {
      return;
    }

    final pngFile = XFile.fromData(
      pngBytes,
      name: filename,
      mimeType: 'image/png',
    );

    await pngFile.saveTo(saveLocation.path);
  }

  Future<bool> startRecording(DeviceId deviceId) async {
    const mp4Group = XTypeGroup(
      label: 'MP4-Videos',
      extensions: ['mp4'],
      uniformTypeIdentifiers: ['public.mpeg-4'],
    );

    final agent = repository.getAgent(deviceId)?.screenCapture;
    if (agent == null) {
      // TODO(Felix): Custom exception type
      throw Exception('Could not resolve agent for device $deviceId');
    }

    final saveLocation = await getSaveLocation(
      acceptedTypeGroups: const [mp4Group],
      suggestedName: 'recording_$deviceId.mp4',
    );

    if (saveLocation == null) {
      return false;
    }

    await agent.startRecording(saveLocation.path);
    return true;
  }

  Future<void> stopRecording(DeviceId deviceId) async {
    final agent = repository.getAgent(deviceId)?.screenCapture;
    if (agent == null) {
      return;
    }

    await agent.stopRecording();
  }

  bool isAudioMuted(DeviceId deviceId) {
    return repository.getAgent(deviceId)?.audio?.isAudioMuted ?? true;
  }

  Future<void> setAudioMuted(DeviceId deviceId, bool muted) async {
    final agent = repository.getAgent(deviceId)?.audio;
    if (agent == null) {
      return;
    }

    await agent.setAudioMuted(muted);
  }

  Future<List<DroppedFileOutcome>> handleDroppedFiles(
    DeviceId deviceId,
    List<String> filepaths,
  ) async {
    final agent = repository.getAgent(deviceId)?.fileTransfer;
    if (agent == null) {
      // TODO(Felix): Custom exception type
      throw Exception('Could not resolve agent for device $deviceId');
    }

    final outcomes = <DroppedFileOutcome>[];

    for (final filepath in filepaths) {
      final filename = path.basename(filepath);
      final isApk = path.extension(filepath).toLowerCase() == '.apk';

      if (isApk) {
        await agent.installApk(filepath);
        outcomes.add((action: .installed, filename: filename));
      } else {
        await agent.pushFile(filepath);
        outcomes.add((action: .pushed, filename: filename));
      }
    }

    return outcomes;
  }

  Future<DroppedFileOutcome?> installApk(DeviceId deviceId) async {
    const apkGroup = XTypeGroup(label: 'APKs', extensions: ['apk']);

    final file = await openFile(acceptedTypeGroups: const [apkGroup]);
    if (file == null) {
      return null;
    }

    final outcomes = await handleDroppedFiles(deviceId, [file.path]);
    return outcomes.isEmpty ? null : outcomes.first;
  }

  Future<DroppedFileOutcome?> shareFile(DeviceId deviceId) async {
    final file = await openFile();
    if (file == null) {
      return null;
    }

    final outcomes = await handleDroppedFiles(deviceId, [file.path]);
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
