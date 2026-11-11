import 'dart:typed_data';

import 'package:synk/feat_device_platform_android/device_agent/android_device_agent_client.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_mirror.dart';

class AndroidScreenCapture({
  required final ScrcpyMirror mirror,
  required final AndroidDeviceAgentCommunicator communicator,
  required final void Function() requestKeyframe,
}) implements DeviceScreenCapture {
  @override
  Future<Uint8List> captureScreenshot() async {
    final response = await communicator.captureScreenshot();
    return Uint8List.fromList(response.png);
  }

  @override
  String? recordingPath;

  @override
  Future<void> startRecording(String path, {required bool withAudio}) async {
    await mirror.startRecording(path, withAudio: withAudio);
    recordingPath = path;
    requestKeyframe();
  }

  @override
  Future<bool> stopRecording() async {
    try {
      return await mirror.stopRecording();
    } finally {
      recordingPath = null;
    }
  }
}
