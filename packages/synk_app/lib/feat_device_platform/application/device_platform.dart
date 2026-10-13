import 'package:synk/feat_device_platform/application/device_agent.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';

abstract interface class DevicePlatform {
  Set<ExternalTool> getToolRequirements();
  Stream<List<PluggedDevice>> observeDevices();

  /// The returned agent owns the connection; disposing it disconnects.
  Future<DeviceAgent> connect(DeviceId deviceId);
  Future<void> dispose();
}
