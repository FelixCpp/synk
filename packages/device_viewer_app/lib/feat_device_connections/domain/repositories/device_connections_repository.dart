import 'package:device_viewer/feat_device_agent/application/android_device_agent.dart';
import 'package:device_viewer/feat_device_connections/domain/models/device_connection.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';

abstract interface class DeviceConnectionsRepository {
  Future<void> dispose();
  Future<void> toggleConnection(AndroidDevice id);
  Future<bool> isConnected(DeviceId id);
  Stream<List<AndroidDevice>> observeConnectingDevices();
  Stream<List<DeviceConnection>> observeDeviceConnections();

  AndroidDeviceAgent? getAgent(DeviceId id);
}

class const DeviceAlreadyConnectingException({
  required final DeviceId deviceId,
}) implements Exception {
  @override
  String toString() => 'Device $deviceId is already connected or connecting.';
}
