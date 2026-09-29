import 'dart:async';

import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_connections_repository.dart';
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
}
