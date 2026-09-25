import 'dart:async';

import 'package:device_viewer/feat_device_canvas/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';
import 'package:use_in_case/use_in_case.dart';

class const StopScreenMirrorInteractor(final DeviceCanvasRepository repository)
    implements ParameterizedInteractor<AndroidDeviceId> {
  @override
  FutureOr<void> getOrThrow(AndroidDeviceId input) {
    return repository.stopScreenMirror(input);
  }
}
