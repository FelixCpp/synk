import 'dart:async';

import 'package:synk/feat_device_frame/domain/device_frame_feature.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:use_in_case/use_in_case.dart';

class const NavigateInteractor(final DeviceFrameFeature feature)
    implements ParameterizedInteractor<DeviceNavigation> {
  @override
  FutureOr<void> getOrThrow(DeviceNavigation input) {
    return feature.navigate(input);
  }
}
