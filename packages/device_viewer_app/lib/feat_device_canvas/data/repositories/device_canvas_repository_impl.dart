import 'dart:async';
import 'dart:typed_data';

import 'package:device_viewer/feat_device_canvas/data/datasources/screen_mirror_texture_datasource.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_devices/adb/domain/repositories/adb_devices_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:file_selector/file_selector.dart';

class DeviceCanvasRepositoryImpl(
  final DeviceConnectionsRepository connectionsRepository,
  final AdbDevicesRepository devicesRepository,
) implements DeviceCanvasRepository {
  final _screenMirrorTexture = ScreenMirrorTextureDatasource();
  final _mirrorSessions = <AndroidDeviceId, _MirrorSession>{};

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
  Future<int> startScreenMirror(AndroidDeviceId deviceId) async {
    final connectedDevice = connectionsRepository.getConnectedAdbDevice(
      deviceId,
    );

    if (connectedDevice == null) {
      throw DeviceNotConnectedException(deviceId: deviceId);
    }

    // Guard against leaking a texture/subscription if a mirror for this
    // device is somehow already running.
    await stopScreenMirror(deviceId);

    final textureId = await _screenMirrorTexture.createTexture();
    final chunks = await connectedDevice.startScreenMirror();
    final subscription = chunks.listen(
      (chunk) => _screenMirrorTexture.sendChunk(textureId, chunk),
    );

    _mirrorSessions[deviceId] = _MirrorSession(
      textureId: textureId,
      subscription: subscription,
    );

    return textureId;
  }

  @override
  Future<void> stopScreenMirror(AndroidDeviceId deviceId) async {
    final session = _mirrorSessions.remove(deviceId);

    if (session == null) {
      return;
    }

    await session.subscription.cancel();
    await _screenMirrorTexture.destroyTexture(session.textureId);

    final device = connectionsRepository.getConnectedAdbDevice(deviceId);
    if (device != null) {
      await device.stopScreenMirror();
    }
  }
}

class const _MirrorSession({
  required final int textureId,
  required final StreamSubscription<Uint8List> subscription,
});
