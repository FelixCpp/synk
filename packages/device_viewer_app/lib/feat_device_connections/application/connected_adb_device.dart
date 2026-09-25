import 'dart:io';
import 'dart:typed_data';

import 'package:api_adb/api_adb.dart';
import 'package:device_viewer/feat_device_agent/application/device_agent_client.dart';
import 'package:device_viewer/feat_device_connections/application/free_port_provider.dart';
import 'package:device_viewer/feat_device_connections/domain/models/adb/adb_device_info.dart';

class ConnectedAdbDevice({
  required final DeviceAgentClient agent,
  required final AdbDeviceConnection connection,
}) {
  AdbPortForward? _videoPortForward;
  Socket? _videoSocket;

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

  /// Starts mirroring the device screen and returns the raw H.264 Annex-B
  /// elementary byte stream. Calling this again while already mirroring
  /// restarts the stream.
  Future<Stream<Uint8List>> startScreenMirror() async {
    await stopScreenMirror();

    final remoteVideoPort = await agent.startScreenStream();
    final localVideoPort = await reserveFreeLocalPort();
    final forward = await connection.forward(
      localPort: localVideoPort,
      remotePort: remoteVideoPort,
    );

    final socket = await Socket.connect(
      InternetAddress.loopbackIPv4,
      forward.localPort,
    );

    _videoPortForward = forward;
    _videoSocket = socket;

    return socket;
  }

  Future<void> stopScreenMirror() async {
    if (_videoSocket == null) {
      return;
    }

    await agent.stopScreenStream();
    await _videoSocket?.close();
    await _videoPortForward?.dispose();
    _videoSocket = null;
    _videoPortForward = null;
  }
}
