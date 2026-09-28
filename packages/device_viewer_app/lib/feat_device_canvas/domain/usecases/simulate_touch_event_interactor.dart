import 'dart:async';

import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_touch_action.dart';
import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:use_in_case/use_in_case.dart';

typedef SimulateTouchEventInput = ({
  AndroidDevice device,
  ScrcpyPointerEvent action,
});

class const SimulateTouchEventInteractor(
  final DeviceCanvasRepository repository,
) implements ParameterizedInteractor<SimulateTouchEventInput> {
  @override
  FutureOr<void> getOrThrow(SimulateTouchEventInput input) async {
    return repository.simulateTouchEvent(input.device, input.action);
  }
}
