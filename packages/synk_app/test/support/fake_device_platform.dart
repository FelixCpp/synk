import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/application/device_agent.dart';
import 'package:synk/feat_device_platform/application/device_platform.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';

import 'fake_device_agent.dart';

/// A platform whose plugged devices and connection attempts a test controls.
class FakePlatform implements DevicePlatform {
  FakePlatform({this.onConnect});

  /// Answers a connection attempt; a fresh [FakeDeviceAgent] without it.
  Future<DeviceAgent> Function(DeviceId deviceId)? onConnect;

  final devices = BehaviorSubject.seeded(<PluggedDevice>[]);
  final connectCalls = <DeviceId>[];
  var isDisposed = false;

  void plug(List<PluggedDevice> plugged) => devices.add(plugged);

  @override
  Set<ExternalTool> getToolRequirements() => const {};

  @override
  Stream<List<PluggedDevice>> observeDevices() => devices;

  @override
  Future<DeviceAgent> connect(DeviceId deviceId) async {
    connectCalls.add(deviceId);
    return await onConnect?.call(deviceId) ?? FakeDeviceAgent();
  }

  @override
  Future<void> dispose() async {
    isDisposed = true;
    await devices.close();
  }
}
