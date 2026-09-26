import 'dart:async';
import 'dart:typed_data';

import 'package:device_viewer/feat_device_agent/application/android_device_agent_client.dart';
import 'package:device_viewer/feat_device_agent/application/android_screen_transmission.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_connections/domain/models/android_device_info.dart';

class AndroidDeviceAgent(
  final AndroidDeviceAgentCommunicator communicator,
  final AndroidScreenTransmission screenTransmission,
) {
  final StreamSubscription<Uint8List> _mirrorSubscription;

  this
    : _mirrorSubscription = screenTransmission.byteStream.listen(
        screenTransmission.texture.upload,
      );

  NativeTextureId get textureId => screenTransmission.texture.id;

  Future<void> dispose() async {
    await _mirrorSubscription.cancel();
    await screenTransmission.dispose();
    await communicator.dispose();
  }

  Future<AndroidDeviceInfo> fetchDeviceInfo() async {
    final response = await communicator.fetchInfo();

    return AndroidDeviceInfo(
      model: response.model,
      manufacturer: response.manufacturer,
      androidVersion: response.androidVersion,
      sdkVersion: response.sdkVersion,
    );
  }

  Future<Uint8List> captureScreenshot() async {
    final response = await communicator.captureScreenshot();
    return Uint8List.fromList(response.png);
  }
}
