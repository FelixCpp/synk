import 'package:synk/feat_device_agent/application/android_device_agent.dart';
import 'package:synk/feat_device_agent/domain/repositories/device_agent_repository.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';

/// Stands in for the adb-backed agent repository when adb is unusable.
class const UnavailableDeviceAgentRepository() implements DeviceAgentRepository {
  @override
  Future<void> dispose() async {}

  @override
  Future<AndroidDeviceAgent> establishConnection(DeviceId deviceId) {
    throw UnsupportedError('adb is unavailable');
  }

  @override
  Future<void> cutConnection(DeviceId deviceId) async {}
}
