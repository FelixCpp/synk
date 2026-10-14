import 'dart:typed_data';

import 'package:synk/feat_device_platform_android/device_agent/android_device_agent_client.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_mirror.dart';

class AndroidScreenCapture({
  required final ScrcpyMirror mirror,
  required final AndroidDeviceAgentCommunicator communicator,
}) implements DeviceScreenCapture {
  @override
  Future<Uint8List> captureScreenshot() async {
    final response = await communicator.captureScreenshot();
    return Uint8List.fromList(response.png);
  }

  @override
  Future<void> startRecording(String path, {required bool withAudio}) {
    return mirror.startRecording(path, withAudio: withAudio);
  }

  @override
  Future<bool> stopRecording() {
    return mirror.stopRecording();
  }
}
