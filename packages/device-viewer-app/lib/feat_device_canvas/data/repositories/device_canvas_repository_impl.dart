import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_devices/adb/domain/repositories/adb_devices_repository.dart';
import 'package:rxdart/rxdart.dart';

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
}
