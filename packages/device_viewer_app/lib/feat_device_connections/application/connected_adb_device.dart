import 'dart:typed_data';

import 'package:api_adb/api_adb.dart';
import 'package:device_viewer/feat_device_agent/application/device_agent_client.dart';
import 'package:device_viewer/feat_device_connections/application/scrcpy/scrcpy_video_session.dart';
import 'package:device_viewer/feat_device_connections/domain/models/adb/adb_device_info.dart';

class ConnectedAdbDevice({
  required final DeviceAgentClient agent,
  required final AdbDeviceConnection connection,
  required final ScrcpyVideoSession scrcpySession,
}) {
  // late final _scrcpySession = ScrcpyVideoSession(
  //   connection: connection,
  //   serverFilepathProvider: scrcpyServerFilepathProvider,
  // );

  Future<AdbAgentDeviceInfo> fetchDeviceInfo() async {
    final response = await agent.fetchInfo();

    return AdbAgentDeviceInfo(
      model: response.model,
      manufacturer: response.manufacturer,
      androidVersion: response.androidVersion,
      sdkVersion: response.sdkVersion,
    );
  }

  Future<Uint8List> captureScreenshot() async {
    final response = await agent.captureScreenshot();
    return Uint8List.fromList(response.png);
  }

  Future<Stream<Uint8List>> startScreenMirror() {
    return scrcpySession.start();
  }

  Future<void> stopScreenMirror() {
    return scrcpySession.stop();
  }
}
