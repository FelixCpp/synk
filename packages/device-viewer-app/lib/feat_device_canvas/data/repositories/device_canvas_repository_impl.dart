import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_devices/adb/domain/repositories/adb_devices_repository.dart';

class const DeviceCanvasRepositoryImpl(
  final DeviceConnectionsRepository connectionsRepository,
  final AdbDevicesRepository devicesRepository,
) implements DeviceCanvasRepository {
  @override
  Stream<List<CanvasDevice>> observeDevices() {
    return devicesRepository.observeAdbDevices().asyncMap((devices) async {
      final canvasDevices = <CanvasDevice>[];

      for (final device in devices) {
        final isConnected = await connectionsRepository.isConnected(device.id);
        canvasDevices.add(.new(isConnected: isConnected, device: device));
      }

      return canvasDevices;
    });
  }
}
