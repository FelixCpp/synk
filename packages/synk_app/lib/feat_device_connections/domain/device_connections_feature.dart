import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/user_facing_exception.dart';

/// What Synk can do with the devices that are plugged in.
abstract interface class DeviceConnectionsFeature {
  Future<void> dispose();
  Future<void> connect(PluggedDevice device);
  Future<void> disconnect(PluggedDevice device);
  bool isConnected(DeviceId id);
  Stream<List<PluggedDevice>> observePluggedDevices();
  Stream<Map<DeviceId, DeviceConnectionState>> observeConnectionStates();
  Stream<List<DeviceConnection>> observeDeviceConnections();
}

class const DeviceAlreadyConnectingException({
  required final DeviceId deviceId,
}) implements UserFacingException {
  @override
  String toString() => 'Das Gerät wird schon verbunden.';
}

class const DeviceNotPluggedException({
  required final DeviceId deviceId,
}) implements UserFacingException {
  @override
  String toString() =>
      'Das Gerät ist nicht mehr angeschlossen. Kabel prüfen und erneut '
      'versuchen.';
}
