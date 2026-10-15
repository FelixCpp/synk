import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_hardware_button.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_hid_channel.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_key_input.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_touch_gesture.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';

class IosInteraction({
  required final IosHidChannel hidChannel,
  required final DeviceId deviceId,
  required Stream<DeviceScreenSize> screenSizeChanges,
}) implements DeviceInteraction {
  late final StreamSubscription<DeviceScreenSize> _screenSizeSubscription;
  late final Timer _orientationPoll;

  var _activeEdge = IosTouchEdge.none;

  this {
    _screenSizeSubscription = screenSizeChanges.listen(
      (_) => _refreshOrientation(),
    );

    _refreshOrientation();
    _orientationPoll = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _refreshOrientation(),
    );
  }

  Future<void> dispose() async {
    _orientationPoll.cancel();
    await _screenSizeSubscription.cancel();
  }

  void _refreshOrientation() {
    unawaited(
      hidChannel.refreshOrientation(deviceId).onError((error, stackTrace) {
        appLogger.w(
          'Failed to refresh the orientation of $deviceId',
          error: error,
          stackTrace: stackTrace,
        );
      }),
    );
  }

  @override
  Future<void> simulateKeyEvent(DeviceKeyEvent event) async {
    final usageCode = iosKeyUsageOf(event.physicalKey);
    if (usageCode == null) {
      return;
    }

    await hidChannel.sendKey(
      deviceId: deviceId,
      usageCode: usageCode,
      isDown: event.type != .up,
    );
  }

  @override
  Future<void> simulatePointerEvent(DevicePointerEvent event) async {
    if (event.type == .down) {
      _activeEdge = iosTouchEdgeAtPointerDown(
        event.normalizedPointerX,
        event.normalizedPointerY,
      );
    }

    _fireAndForget(
      hidChannel.sendTouch(
        deviceId: deviceId,
        point: (x: event.normalizedPointerX, y: event.normalizedPointerY),
        phase: iosTouchPhaseOf(event.type),
        edge: _activeEdge,
      ),
    );
  }

  @override
  Future<void> simulatePinchEvent(PinchEvent event) async {
    final leftX = _clampedToScreen(event.centerX - event.spread);
    final rightX = _clampedToScreen(event.centerX + event.spread);

    _fireAndForget(
      hidChannel.sendTouch(
        deviceId: deviceId,
        point: (x: leftX, y: event.centerY),
        secondPoint: (x: rightX, y: event.centerY),
        phase: iosTouchPhaseOf(event.type),
        edge: .none,
      ),
    );
  }

  @override
  Set<DeviceNavigation> get supportedNavigations {
    return const {.home};
  }

  @override
  Future<void> navigate(DeviceNavigation navigation) async {
    if (!supportedNavigations.contains(navigation)) {
      return;
    }

    await hidChannel.sendSwipe(
      deviceId: deviceId,
      swipe: iosSwipeForNavigation(navigation),
    );
  }

  @override
  Future<void> pressPowerButton() async {
    await hidChannel.pressButton(deviceId: deviceId, button: iosPowerButton);
  }

  void _fireAndForget(Future<void> send) {
    unawaited(
      send.onError((error, stackTrace) {
        appLogger.w(
          'Failed to send a touch to $deviceId',
          error: error,
          stackTrace: stackTrace,
        );
      }),
    );
  }
}

double _clampedToScreen(double normalizedPosition) {
  return normalizedPosition.clamp(0.0, 1.0);
}
