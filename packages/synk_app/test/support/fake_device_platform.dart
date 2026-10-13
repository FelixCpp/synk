import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/application/device_platform.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';

import 'fake_device_session.dart';

/// A platform whose plugged devices and connection attempts a test controls.
class FakePlatform implements DevicePlatform {
  FakePlatform({this.onConnect});

  /// Answers a connection attempt; a fresh [FakeDeviceSession] without it.
  Future<DeviceSession> Function(DeviceId deviceId)? onConnect;

  final devices = BehaviorSubject.seeded(<PluggedDevice>[]);
  final connectCalls = <DeviceId>[];
  var isDisposed = false;

  void plug(List<PluggedDevice> plugged) => devices.add(plugged);

  @override
  Set<ExternalTool> getToolRequirements() => const {};

  @override
  Stream<List<PluggedDevice>> observeDevices() => devices;

  @override
  Future<DeviceSession> connect(DeviceId deviceId) async {
    connectCalls.add(deviceId);
    return await onConnect?.call(deviceId) ?? FakeDeviceSession();
  }

  @override
  Future<void> dispose() async {
    isDisposed = true;
    await devices.close();
  }
}
