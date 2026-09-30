import 'package:device_viewer/feat_device_agent/application/ios_device_agent.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';

abstract interface class IosDeviceAgentRepository {
  Future<void> dispose();
  Future<IosDeviceAgent> establishConnection(DeviceId deviceId);
  Future<void> cutConnection(DeviceId deviceId);
}
