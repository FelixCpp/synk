import 'dart:typed_data';

import 'package:synk/feat_device_platform_android/device_agent/android_device_agent_client.dart';
import 'package:synk/feat_device_platform/application/agents/screen_capture_device_agent.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_session.dart';

class AndroidScreenCaptureDeviceAgent({
  required final ScrcpySession session,
  required final AndroidDeviceAgentCommunicator communicator,
}) implements ScreenCaptureDeviceAgent {
  @override
  Future<Uint8List> captureScreenshot() async {
    final response = await communicator.captureScreenshot();
    return Uint8List.fromList(response.png);
  }

  @override
  Future<void> startRecording(String path) {
    return session.startRecording(path);
  }

  @override
  Future<bool> stopRecording() {
    return session.stopRecording();
  }
}
