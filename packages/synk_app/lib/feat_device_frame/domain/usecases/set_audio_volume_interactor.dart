import 'dart:async';

import 'package:synk/feat_device_frame/domain/device_frame_feature.dart';
import 'package:use_in_case/use_in_case.dart';

class const SetAudioVolumeInteractor(final DeviceFrameFeature feature)
    implements ParameterizedInteractor<double> {
  @override
  FutureOr<void> getOrThrow(double input) {
    return feature.setAudioVolume(input);
  }
}
