import 'dart:io';

import 'package:api_adb/api_adb.dart';
import 'package:device_viewer/feat_device_agent/application/device_agent_client.dart';
import 'package:device_viewer/feat_device_connections/application/adb_agent_session.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';

class const AdbAgentSessionBootstrapper({required final AdbApi api}) {
  Future<AdbAgentSession> connect(AndroidDevice device) async {
    final adbConnection = api.connect(device.id);
    // TODO(Felix): Agent start must be implemented here
    final portForward = await adbConnection.forward(
      localPort: 27183,
      remotePort: 27183,
    );

    final socket = await Socket.connect(
      InternetAddress.loopbackIPv4,
      portForward.localPort,
    );

    final agent = DeviceAgentClient(socket: socket);

    return AdbAgentSession(
      adbConnection: adbConnection,
      portForward: portForward,
      agent: agent,
    );
  }
}
