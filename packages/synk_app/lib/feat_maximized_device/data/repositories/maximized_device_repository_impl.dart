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
    return Rx.combineLatest2(
      connectionsRepository.observeConnectingDevices(),
      connectionsRepository.observeDeviceConnections(),
      (connecting, connected) {
        for (final connection in connected) {
          if (connection.device.id != deviceId) continue;

          return MaximizedDevice(
            deviceId: deviceId,
            modelName: connection.device.modelName,
            isLive: true,
            textureId: connection.textureId,
            screenSize: connection.screenSize,
            supportsInteraction: connection.supportsInteraction,
            supportsDeviceActions: connection.device is AndroidDevice,
          );
        }

        for (final device in connecting) {
          if (device.id != deviceId) continue;

          return MaximizedDevice(
            deviceId: deviceId,
            modelName: device.modelName,
            isLive: false,
            textureId: null,
            screenSize: null,
            supportsInteraction: device is AndroidDevice,
            supportsDeviceActions: device is AndroidDevice,
          );
        }

        return null;
      },
    ).distinct();
  }
}
