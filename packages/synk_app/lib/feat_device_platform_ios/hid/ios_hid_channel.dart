import 'package:synk/feat_device_platform/domain/models/screen_orientation.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_hardware_button.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_touch_gesture.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:flutter/services.dart';

enum IosInputProblem {
  coreDeviceUnavailable,
  deviceUnknown,
  preparationFailed,
}

class IosHidChannel {
  static const _channel = MethodChannel('dev.synk/ios_hid');

  Future<IosInputProblem?> prepareInput(DeviceId deviceId) async {
    final problem = await _channel.invokeMethod<String>('prepareInput', {
      'deviceId': deviceId.value,
    });

    return problem == null ? null : IosInputProblem.values.byName(problem);
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

  Future<void> setOrientation({
    required DeviceId deviceId,
    required ScreenOrientation orientation,
  }) {
    return _channel.invokeMethod('setOrientation', {
      'deviceId': deviceId.value,
      'orientation': switch (orientation) {
        .portrait => 'portrait',
        .landscapeLeft => 'landscapeLeft',
        .portraitUpsideDown => 'portraitUpsideDown',
        .landscapeRight => 'landscapeRight',
      },
    });
  }
}
