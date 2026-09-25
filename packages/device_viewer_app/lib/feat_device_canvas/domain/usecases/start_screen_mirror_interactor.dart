import 'dart:async';

import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';
import 'package:use_in_case/use_in_case.dart';

class const StartScreenMirrorInteractor(final DeviceCanvasRepository repository)
    implements ParameterizedResultInteractor<AndroidDeviceId, int> {
  @override
  FutureOr<int> getOrThrow(AndroidDeviceId input) {
    return repository.startScreenMirror(input);
  }
}
