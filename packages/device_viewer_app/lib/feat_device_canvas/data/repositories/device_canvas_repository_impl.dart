import 'dart:async';

import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_key_event.dart';
import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_touch_action.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:file_selector/file_selector.dart';
import 'package:rxdart/rxdart.dart';

class DeviceCanvasRepositoryImpl(
  final DeviceConnectionsRepository connectionsRepository,
) implements DeviceCanvasRepository {
  @override
  Stream<List<CanvasDevice>> observeDevices() {
    return Rx.combineLatest2(
      connectionsRepository.observeConnectingDevices(),
      connectionsRepository.observeDeviceConnections(),
      (connecting, connected) => (connecting, connected),
    ).map((pair) {
      final (connecting, connected) = pair;
      final connectedIds = {for (final c in connected) c.device.id};

      return [
        for (final device in connecting)
          if (!connectedIds.contains(device.id))
            CanvasDevice.connecting(device: device),

        for (final connection in connected)
          CanvasDevice.android(
            device: connection.device,
            isConnected: true,
            textureId: connection.textureId,
            screenSize: connection.screenSize,
          ),
      ];
    });
  }

  @override
  Future<void> captureScreenshot(AndroidDevice device) async {
    const pngGroup = XTypeGroup(
      label: 'PNGs',
      extensions: ['png'],
      uniformTypeIdentifiers: ['public.png'],
    );

    final agent = connectionsRepository.getAndroidDeviceAgent(device.id);
    if (agent == null) {
      throw DeviceNotConnectedException(deviceId: device.id);
    }

    final pngBytes = await agent.captureScreenshot();
    final filename = 'screenshot_${device.id}.png';
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
  void simulateTouchEvent(AndroidDevice device, ScrcpyPointerEvent event) {
    final agent = connectionsRepository.getAndroidDeviceAgent(device.id);
    if (agent == null) {
      throw Exception('Failed to receive device agent (${device.id})');
    }

    agent.simulateTouchEvent(event);
  }

  @override
  void simulateKeyEvent(AndroidDevice device, ScrcpyKeyEvent event) {
    final agent = connectionsRepository.getAndroidDeviceAgent(device.id);
    if (agent == null) {
      throw Exception('Failed to receive device agent (${device.id})');
    }

    agent.simulateKeyEvent(event);
  }

  @override
  void wakeupDevice(AndroidDevice device) {
    final agent = connectionsRepository.getAndroidDeviceAgent(device.id);
    if (agent == null) {
      throw Exception('Failed to receive device agent (${device.id})');
    }

    for (final type in [ScrcpyKeyEventType.down, ScrcpyKeyEventType.up]) {
      agent.simulateKeyEvent(
        ScrcpyKeyEvent(keyCode: .wakeup, metaState: .none, type: type),
      );
    }
  }
}
