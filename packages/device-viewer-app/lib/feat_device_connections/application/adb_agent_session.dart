import 'package:api_adb/adb/application/adb_device_connection.dart';
import 'package:device_viewer/feat_device_agent/application/device_agent_client.dart';

class const AdbAgentSession({
  required final AdbDeviceConnection adbConnection,
  required final DeviceAgentClient agent,
  required final AdbPortForward portForward,
}) {
  Future<void> dispose() {
    return agent.dispose();
  }
}
