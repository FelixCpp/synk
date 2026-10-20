import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/device_connections_feature.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';

class const MaximizedDeviceWatch({
  required final DeviceConnectionsFeature connectionsRepository,
}) {
  /// Emits `null` once the device is no longer connected.
  Stream<DeviceConnection?> observe(DeviceId deviceId) {
    return connectionsRepository.observeDeviceConnections().map(
      (connections) {
        return connections
            .where((connection) => connection.device.id == deviceId)
            .firstOrNull;
      },
    ).distinct();
  }
}
