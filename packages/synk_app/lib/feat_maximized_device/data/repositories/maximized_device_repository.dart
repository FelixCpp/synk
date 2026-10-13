import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';

class const MaximizedDeviceRepository({
  required final DeviceConnectionsRepository connectionsRepository,
}) {
  /// Emits `null` once the device is no longer connected.
  Stream<DeviceConnection?> observeDevice(DeviceId deviceId) {
    return connectionsRepository.observeDeviceConnections().map(
      (connections) {
        return connections
            .where((connection) => connection.device.id == deviceId)
            .firstOrNull;
      },
    ).distinct();
  }
}
