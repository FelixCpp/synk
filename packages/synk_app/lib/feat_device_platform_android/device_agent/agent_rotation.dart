import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/domain/models/screen_orientation.dart';
import 'package:synk/feat_device_platform_android/device_agent/android_device_agent_client.dart';

class AgentRotation(
  final AndroidDeviceAgentCommunicator communicator, {
  required final ValueStream<DeviceScreenSize> screenSize,
}) {
  ScreenOrientation? _orientation;

  Future<void> rotate(DeviceRotationDirection direction) async {
    final orientation = (_orientation ?? .guessedFrom(screenSize.value)).turned(
      direction,
    );

    await communicator.lockRotation(switch (orientation) {
      .portrait => 0,
      .landscapeLeft => 1,
      .portraitUpsideDown => 2,
      .landscapeRight => 3,
    });
    _orientation = orientation;
  }

  Future<void> restoreAutoRotation() {
    return communicator.restoreRotation();
  }
}
