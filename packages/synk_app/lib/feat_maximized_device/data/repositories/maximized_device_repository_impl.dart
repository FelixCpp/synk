import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_maximized_device/domain/models/maximized_device.dart';
import 'package:synk/feat_maximized_device/domain/repositories/maximized_device_repository.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:rxdart/rxdart.dart';

class const MaximizedDeviceRepositoryImpl({
  required final DeviceConnectionsRepository connectionsRepository,
}) implements MaximizedDeviceRepository {
  @override
  Stream<MaximizedDevice?> observeDevice(DeviceId deviceId) {
    return connectionsRepository.observeDeviceConnections().mapNotNull(
      (connections) {
        final connection = connections
            .where((connection) => connection.device.id == deviceId)
            .firstOrNull;

        if (connection == null) {
          return null;
        }

        return MaximizedDevice(
          deviceId: connection.device.id,
          modelName: connection.device.modelName,
          textureId: connection.textureId,
          screenSize: connection.screenSize,
          supportsInteraction: connection.supportsInteraction,
          supportsDeviceActions: connection.device is AndroidDevice,
          supportsAudio: connection.supportsAudio,
        );
      },
    ).distinct();
  }
}
