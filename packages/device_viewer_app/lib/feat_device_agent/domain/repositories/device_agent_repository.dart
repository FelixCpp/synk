import 'package:device_viewer/feat_device_agent/application/android_device_agent.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';

abstract interface class DeviceAgentRepository {
  Future<void> dispose();
  Future<AndroidDeviceAgent> establishConnection(DeviceId deviceId);
  Future<void> cutConnection(DeviceId deviceId);
}

class const DeviceAgentAlreadyConnectedException({
  required final DeviceId deviceId,
}) implements Exception {
  @override
  String toString() {
    return 'Connection already established to device $deviceId.';
  }
}

class const DeviceAgentNotConnectedException({
  required final DeviceId deviceId,
}) implements Exception {
  @override
  String toString() {
    return 'Tried to close connection to unconnected device $deviceId.';
  }
}
