import 'package:device_viewer/feat_device_connections/application/connected_adb_device.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';

abstract interface class DeviceConnectionsRepository {
  Future<void> dispose();
  Future<void> toggleConnection(AndroidDevice id);
  Future<bool> isConnected(AndroidDeviceId id);
  Stream<Set<AndroidDeviceId>> observeConnectedDeviceIds();

  ConnectedAdbDevice? getConnectedAdbDevice(AndroidDeviceId id);
}
