import 'package:synk/feat_device_agent/application/android_device_agent.dart';
import 'package:synk/feat_device_agent/application/ios_device_agent.dart';
import 'package:synk/feat_device_agent/domain/models/clipboard_agent.dart';
import 'package:synk/feat_device_agent/domain/models/interaction_agent.dart';
import 'package:synk/feat_device_agent/domain/models/screen_capture_agent.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';

abstract interface class DeviceConnectionsRepository {
  Future<void> dispose();
  Future<void> toggleConnection(PluggedDevice device);
  Future<bool> isConnected(DeviceId id);
  Stream<List<PluggedDevice>> observeConnectingDevices();
  Stream<List<DeviceConnection>> observeDeviceConnections();

  AndroidDeviceAgent? getAndroidDeviceAgent(DeviceId id);
  IosDeviceAgent? getIosDeviceAgent(DeviceId id);
  ScreenCaptureAgent? getScreenCaptureAgent(DeviceId id);
  ClipboardAgent? getClipboardAgent(DeviceId id);
  InteractionAgent? getInteractionAgent(DeviceId id);
}

class const DeviceAlreadyConnectingException({
  required final DeviceId deviceId,
}) implements Exception {
  @override
  String toString() => 'Device $deviceId is already connected or connecting.';
}
