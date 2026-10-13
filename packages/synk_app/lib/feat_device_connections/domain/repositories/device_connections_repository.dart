import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_platform/application/device_agent.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';

abstract interface class DeviceConnectionsRepository {
  Future<void> dispose();
  Future<void> toggleConnection(PluggedDevice device);
  bool isConnected(DeviceId id);
  Stream<List<PluggedDevice>> observePluggedDevices();
  Stream<Map<DeviceId, DeviceConnectionState>> observeConnectionStates();
  Stream<List<DeviceConnection>> observeDeviceConnections();

  DeviceAgent? getAgent(DeviceId id);
}

class const DeviceAlreadyConnectingException({
  required final DeviceId deviceId,
}) implements Exception {
  @override
  String toString() => 'Device $deviceId is already connected or connecting.';
}

class const DeviceNotPluggedException({
  required final DeviceId deviceId,
}) implements Exception {
  @override
  String toString() => 'Device $deviceId is not plugged in.';
}
