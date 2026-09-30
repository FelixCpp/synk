import 'package:device_viewer/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/repositories/plugged_adb_devices_repository.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:device_viewer/feat_plugged_devices/ios/domain/repositories/plugged_ios_devices_repository.dart';
import 'package:device_viewer/feat_sidebar/domain/models/sidebar_device.dart';
import 'package:device_viewer/feat_sidebar/domain/repositories/sidebar_repository.dart';
import 'package:rxdart/rxdart.dart';

class const SidebarRepositoryImpl(
  final DeviceConnectionsRepository connectionsRepository,
  final PluggedAdbDevicesRepository adbDevicesRepository,
  final PluggedIosDevicesRepository iosDevicesRepository,
) implements SidebarRepository {
  @override
  Stream<List<SidebarDevice>> observeDevices() {
    return Rx.combineLatest3(
      adbDevicesRepository.observeAdbDevices(),
      iosDevicesRepository.observeIosDevices(),
      connectionsRepository.observeDeviceConnections(),
      (androidDevices, iosDevices, connections) =>
          (<PluggedDevice>[...androidDevices, ...iosDevices], connections),
    ).asyncMap((pair) async {
      final (devices, connections) = pair;

      final canvasDevices = <SidebarDevice>[];

      for (final device in devices) {
        final isConnected = await connectionsRepository.isConnected(device.id);
        canvasDevices.add(.new(isConnected: isConnected, device: device));
      }

      return canvasDevices;
    });
  }
}
