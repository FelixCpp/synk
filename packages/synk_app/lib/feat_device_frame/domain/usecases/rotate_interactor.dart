import 'dart:async';

import 'package:synk/feat_device_frame/domain/device_frame_feature.dart';
import 'package:synk/feat_device_platform/domain/models/screen_orientation.dart';
import 'package:use_in_case/use_in_case.dart';

class const RotateInteractor(final DeviceFrameFeature feature)
    implements ParameterizedInteractor<DeviceRotationDirection> {
  @override
  FutureOr<void> execute(DeviceRotationDirection input) {
    return feature.rotate(input);
  }
}
