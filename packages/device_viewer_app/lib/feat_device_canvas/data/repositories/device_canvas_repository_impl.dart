import 'dart:async';

import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:file_selector/file_selector.dart';

class DeviceCanvasRepositoryImpl(
  final DeviceConnectionsRepository connectionsRepository,
) implements DeviceCanvasRepository {
  @override
  Stream<List<CanvasDevice>> observeDevices() {
    return connectionsRepository.observeDeviceConnections().map((
      connections,
    ) {
      return [
        for (final connection in connections)
          CanvasDevice.android(
            device: connection.device,
            isConnected: true,
            textureId: connection.textureId,
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

    final agent = connectionsRepository.getAgent(device.id);
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
}
