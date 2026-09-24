import 'package:device_viewer/feat_device_connections/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_devices/adb/domain/repositories/adb_devices_repository.dart';
import 'package:device_viewer/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:device_viewer/feat_sidebar/domain/repositories/sidebar_repository.dart';

class const SidebarRepositoryImpl(
  final DeviceConnectionsRepository connectionsRepository,
  final AdbDevicesRepository devicesRepository,
) implements SidebarRepository {
  @override
  Stream<List<SidebarDevice>> observeDevices() {
    return devicesRepository.observeAdbDevices().asyncMap((devices) async {
      final canvasDevices = <SidebarDevice>[];

      for (final device in devices) {
        final isConnected = await connectionsRepository.isConnected(device.id);
        canvasDevices.add(.new(isConnected: isConnected, device: device));
      }

      return canvasDevices;
    });
  }
}
