import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/mirror_options.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';

abstract interface class DevicePlatform {
  Set<ExternalTool> getRequiredTools();
  Stream<List<PluggedDevice>> observeDevices();
  Future<DeviceSession> connect(DeviceId deviceId, MirrorOptions options);
  Future<void> dispose();
}
