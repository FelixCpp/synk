import 'dart:async';

import 'package:synk/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:synk/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device.dart';
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
            CanvasDevice.connecting(
              device: device,
              supportsInteraction: device is AndroidDevice,
              supportsDeviceActions: device is AndroidDevice,
              // Not known before the stream is negotiated.
              supportsAudio: false,
            ),

        for (final connection in connected)
          CanvasDevice.connected(
            device: connection.device,
            isConnected: true,
            textureId: connection.textureId,
            screenSize: connection.screenSize,
            supportsInteraction: connection.supportsInteraction,
            supportsDeviceActions: connection.device is AndroidDevice,
            supportsAudio: connection.supportsAudio,
          ),
      ];
    });
  }
}
