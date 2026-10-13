import 'package:synk/feat_device_platform_ios/hid/ios_hardware_button.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_touch_gesture.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:flutter/services.dart';

class IosHidChannel {
  static const _channel = MethodChannel('dev.synk/ios_hid');

  Future<bool> prepareInput(DeviceId deviceId) async {
    final prepared = await _channel.invokeMethod<bool>('prepareInput', {
      'deviceId': deviceId.value,
    });

    return prepared ?? false;
  }

  Future<void> releaseInput(DeviceId deviceId) {
    return _channel.invokeMethod('releaseInput', {'deviceId': deviceId.value});
  }

  Future<void> refreshOrientation(DeviceId deviceId) {
    return _channel.invokeMethod('refreshOrientation', {
      'deviceId': deviceId.value,
    });
  }

  Future<void> sendTouch({
    required DeviceId deviceId,
    required IosTouchPoint point,
    required IosTouchPhase phase,
    required IosTouchEdge edge,
    IosTouchPoint? secondPoint,
  }) {
    return _channel.invokeMethod('sendTouch', {
      'deviceId': deviceId.value,
      'x': point.x,
      'y': point.y,
      'phase': phase.name,
      'edge': edge.name,
      if (secondPoint != null) ...{
        'secondX': secondPoint.x,
        'secondY': secondPoint.y,
      },
    });
  }

  Future<void> sendKey({
    required DeviceId deviceId,
    required int usageCode,
    required bool isDown,
  }) {
    return _channel.invokeMethod('sendKey', {
      'deviceId': deviceId.value,
      'usage': usageCode,
      'isDown': isDown,
    });
  }

  Future<void> pressButton({
    required DeviceId deviceId,
    required IosHardwareButton button,
  }) {
    return _channel.invokeMethod('pressButton', {
      'deviceId': deviceId.value,
      'usagePage': button.usagePage,
      'usageCode': button.usageCode,
    });
  }

  Future<void> sendSwipe({
    required DeviceId deviceId,
    required IosSwipe swipe,
  }) {
    return _channel.invokeMethod('sendSwipe', {
      'deviceId': deviceId.value,
      'fromX': swipe.from.x,
      'fromY': swipe.from.y,
      'toX': swipe.to.x,
      'toY': swipe.to.y,
      'edge': swipe.edge.name,
      'holdMs': swipe.hold.inMilliseconds,
    });
  }
}
