import 'dart:async';

import 'package:synk/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:synk/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';

class DeviceCanvasRepositoryImpl(
  final DeviceConnectionsRepository connectionsRepository,
) implements DeviceCanvasRepository {
  @override
  Stream<List<CanvasDevice>> observeDevices() {
    return connectionsRepository.observeDeviceConnections().map((connections) {
      return [
        for (final connection in connections)
          CanvasDevice(
            device: connection.device,
            textureId: connection.textureId,
            screenSize: connection.screenSize,
            supportsInteraction: connection.supportsInteraction,
            supportsDeviceActions: connection.device.supportsDeviceActions,
            supportsAudio: connection.supportsAudio,
          ),
      ];
    });
  }
}
