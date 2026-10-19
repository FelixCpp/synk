import 'dart:async';

import 'package:synk/feat_device_frame/domain/device_frame_feature.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:use_in_case/use_in_case.dart';

class const SimulateKeyEventInteractor(final DeviceFrameFeature feature)
    implements ParameterizedInteractor<DeviceKeyEvent> {
  @override
  FutureOr<void> getOrThrow(DeviceKeyEvent input) {
    return feature.simulateKeyEvent(input);
  }
}
