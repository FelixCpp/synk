import 'dart:async';

import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_key_action.dart';
import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:use_in_case/use_in_case.dart';

typedef SimulateKeyEventInput = ({
  AndroidDevice device,
  ScrcpyKeyAction action,
});

class const SimulateKeyEventInteractor(
  final DeviceCanvasRepository repository,
) implements ParameterizedInteractor<SimulateKeyEventInput> {
  @override
  FutureOr<void> getOrThrow(SimulateKeyEventInput input) async {
    repository.simulateKeyEvent(input.device, input.action);
  }
}
