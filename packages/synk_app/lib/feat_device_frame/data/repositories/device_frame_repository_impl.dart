import 'package:app_logger/app_logger.dart';
import 'package:synk/feat_device_agent/domain/models/clipboard_agent.dart';
import 'package:synk/feat_device_agent/domain/models/device_key_event.dart';
import 'package:synk/feat_device_agent/domain/models/device_pointer_event.dart';
import 'package:synk/feat_device_agent/domain/models/interaction_agent.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_frame/domain/models/control_button_type.dart';
import 'package:synk/feat_device_frame/domain/models/dropped_file_outcome.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

class const DeviceFrameRepositoryImpl({
  required final DeviceConnectionsRepository repository,
}) implements DeviceFrameRepository {
  @override
  Future<void> simulateKeyEvent(DeviceId deviceId, DeviceKeyEvent event) async {
    final shortcut = _clipboardShortcutOf(event);
    if (shortcut == null) {
      await repository.getInteractionAgent(deviceId)?.simulateKeyEvent(event);
      return;
    }

    if (event.type != .down) {
      return;
    }

    final agent = repository.getClipboardAgent(deviceId);
    if (agent == null) {
      return;
    }

    await switch (shortcut) {
      .copyFromDevice => _copyFromDevice(deviceId, agent),
      .pasteToDevice => _pasteToDevice(deviceId, agent),
    };
  }

  Future<void> _copyFromDevice(DeviceId deviceId, ClipboardAgent agent) async {
    final String text;
    try {
      text = await agent.readDeviceClipboardContent();
    } on Object catch (error, stackTrace) {
      _logUnreachableClipboard(deviceId, error, stackTrace);
      return;
    }

    if (text.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> _pasteToDevice(DeviceId deviceId, ClipboardAgent agent) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if (text == null) {
      return;
    }

    try {
      await agent.setDeviceClipboardContent(text);
    } on Object catch (error, stackTrace) {
      _logUnreachableClipboard(deviceId, error, stackTrace);
    }
  }

  void _logUnreachableClipboard(
    DeviceId deviceId,
    Object error,
    StackTrace stackTrace,
  ) {
    appLogger.w(
      'No clipboard sync for $deviceId; swallowing the shortcut',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  Future<void> simulatePointerEvent(
    DeviceId deviceId,
    DevicePointerEvent event,
  ) async {
    await repository.getInteractionAgent(deviceId)?.simulatePointerEvent(event);
  }

  @override
  Future<void> simulatePinchEvent(DeviceId deviceId, PinchEvent event) async {
    await repository.getInteractionAgent(deviceId)?.simulatePinchEvent(event);
  }

  @override
  Future<void> simulateControlButtonEvent(
    DeviceId deviceId,
    ControlButtonType type,
  ) async {
    final DeviceControlAction action = switch (type) {
      .back => .back,
      .home => .home,
      .appSwitch => .appSwitch,
      .power => .standby,
    };

    final agent = repository.getInteractionAgent(deviceId);
    await agent?.simulateControlAction(action);
  }

  @override
  Future<void> captureScreenshot(DeviceId deviceId) async {
    const pngGroup = XTypeGroup(
      label: 'PNGs',
      extensions: ['png'],
      uniformTypeIdentifiers: ['public.png'],
    );

    final agent = repository.getScreenCaptureAgent(deviceId);
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

  @override
  Future<bool> startRecording(DeviceId deviceId) async {
    const mp4Group = XTypeGroup(
      label: 'MP4-Videos',
      extensions: ['mp4'],
      uniformTypeIdentifiers: ['public.mpeg-4'],
    );

    final agent = repository.getScreenCaptureAgent(deviceId);
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

  @override
  Future<void> stopRecording(DeviceId deviceId) async {
    final agent = repository.getScreenCaptureAgent(deviceId);
    if (agent == null) {
      return;
    }

    await agent.stopRecording();
  }

  @override
  bool isAudioMuted(DeviceId deviceId) {
    return repository.getAudioAgent(deviceId)?.isAudioMuted ?? true;
  }

  @override
  Future<void> setAudioMuted(DeviceId deviceId, bool muted) async {
    final agent = repository.getAudioAgent(deviceId);
    if (agent == null) {
      return;
    }

    await agent.setAudioMuted(muted);
  }

  @override
  Future<List<DroppedFileOutcome>> handleDroppedFiles(
    DeviceId deviceId,
    List<String> filepaths,
  ) async {
    final agent = repository.getAndroidDeviceAgent(deviceId);
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

  @override
  Future<DroppedFileOutcome?> installApk(DeviceId deviceId) async {
    const apkGroup = XTypeGroup(label: 'APKs', extensions: ['apk']);

    final file = await openFile(acceptedTypeGroups: const [apkGroup]);
    if (file == null) {
      return null;
    }

    final outcomes = await handleDroppedFiles(deviceId, [file.path]);
    return outcomes.isEmpty ? null : outcomes.first;
  }

  @override
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
