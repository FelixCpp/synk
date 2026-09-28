import 'dart:async';

import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:use_in_case/use_in_case.dart';

class const WakeupDeviceInteractor(
  final DeviceCanvasRepository repository,
) implements ParameterizedInteractor<AndroidDevice> {
  @override
  FutureOr<void> getOrThrow(AndroidDevice input) async {
    return repository.wakeupDevice(input);
  }
}
