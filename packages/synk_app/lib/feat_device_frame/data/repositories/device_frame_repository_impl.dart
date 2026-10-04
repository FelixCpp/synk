import 'package:synk/feat_device_agent/application/android_device_agent.dart';
import 'package:synk/feat_device_agent/domain/models/scrcpy_key_event.dart';
import 'package:synk/feat_device_agent/domain/models/scrcpy_pointer_action.dart';
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
  Future<void> simulateKeyEvent(DeviceId deviceId, ScrcpyKeyEvent event) async {
    final agent = repository.getAndroidDeviceAgent(deviceId);
    if (agent == null) {
      return;
    }

    final isMetaKeyDown = (event.metaState & ScrcpyKeyMetaState.metaOn) != 0;
    final isCopyEvent = isMetaKeyDown && event.keyCode == .copy;
    final isPasteEvent = isMetaKeyDown && event.keyCode == .paste;

    if (isCopyEvent) {
      if (event.type == .down) {
        await _copyFromDevice(agent);
      }

      return;
    }

    if (isPasteEvent) {
      if (event.type == .down) {
        await _pasteToDevice(agent);
      }

      return;
    }

    agent.simulateKeyEvent(event);
  }

  Future<void> _copyFromDevice(AndroidDeviceAgent agent) async {
    final text = await agent.readDeviceClipboardContent();
    await Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> _pasteToDevice(AndroidDeviceAgent agent) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if (text == null) {
      return;
    }

    agent.setDeviceClipboardContent(text);
  }

  @override
  void simulatePointerEvent(DeviceId deviceId, ScrcpyPointerEvent event) {
    final agent = repository.getAndroidDeviceAgent(deviceId);
    if (agent == null) {
      return;
    }

    if (event.type == .down) {
      wakeup(agent);
    }

    agent.simulatePointerEvent(event);
  }

  @override
  void simulateControlButtonEvent(DeviceId deviceId, ControlButtonType type) {
    final agent = repository.getAndroidDeviceAgent(deviceId);
    if (agent == null) {
      return;
    }

    final ScrcpyKeyCode keyCode = switch (type) {
      .back => .back,
      .home => .home,
      .appSwitch => .appSwitch,
      .power => .power,
    };

    _pressKey(agent, keyCode);
  }

  void wakeup(AndroidDeviceAgent agent) {
    _pressKey(agent, .wakeup);
  }

  void _pressKey(AndroidDeviceAgent agent, ScrcpyKeyCode keyCode) {
    for (final type in [ScrcpyKeyEventType.down, ScrcpyKeyEventType.up]) {
      agent.simulateKeyEvent(
        ScrcpyKeyEvent(
          keyCode: keyCode,
          metaState: .none,
          type: type,
        ),
      );
    }
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
    return repository.getAndroidDeviceAgent(deviceId)?.isAudioMuted ?? true;
  }

  @override
  Future<void> setAudioMuted(DeviceId deviceId, bool muted) async {
    final agent = repository.getAndroidDeviceAgent(deviceId);
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
