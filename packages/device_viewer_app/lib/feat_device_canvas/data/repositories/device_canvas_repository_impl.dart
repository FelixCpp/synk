import 'dart:typed_data';

import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_devices/adb/domain/repositories/adb_devices_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:file_selector/file_selector.dart';

class const DeviceCanvasRepositoryImpl(
  final DeviceConnectionsRepository connectionsRepository,
  final AdbDevicesRepository devicesRepository,
) implements DeviceCanvasRepository {
  @override
  Stream<List<CanvasDevice>> observeDevices() {
    return Rx.combineLatest2(
      devicesRepository.observeAdbDevices(),
      connectionsRepository.observeConnectedDeviceIds(),
      (devices, connections) => (devices, connections),
    ).map((pair) {
      final (devices, connectedIds) = pair;
      final devicesById = {for (final device in devices) device.id: device};

      return [
        for (final id in connectedIds)
          if (devicesById[id] case final device?)
            CanvasDevice(isConnected: true, device: device),
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

    final connectedDevice = connectionsRepository.getConnectedAdbDevice(
      device.id,
    );

    if (connectedDevice == null) {
      throw DeviceNotConnectedException(deviceId: device.id);
    }

    final pngBytes = await connectedDevice.captureScreenshot();
    final deviceLabel = device.info.model ?? device.id;
    final filename = 'screenshot_$deviceLabel.png';
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
  Future<Stream<Uint8List>> startScreenMirror(AndroidDevice device) async {
    final connectedDevice = connectionsRepository.getConnectedAdbDevice(
      device.id,
    );

    if (connectedDevice == null) {
      throw DeviceNotConnectedException(deviceId: device.id);
    }

    return connectedDevice.startScreenMirror();
  }

  @override
  Future<void> stopScreenMirror(AndroidDevice device) async {
    await connectionsRepository.getConnectedAdbDevice(device.id)?.stopScreenMirror();
  }
}
