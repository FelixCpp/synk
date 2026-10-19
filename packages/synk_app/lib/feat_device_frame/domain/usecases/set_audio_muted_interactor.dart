import 'dart:async';

import 'package:synk/feat_device_frame/domain/device_frame_feature.dart';
import 'package:use_in_case/use_in_case.dart';

class const SetAudioMutedInteractor(final DeviceFrameFeature feature)
    implements ParameterizedInteractor<bool> {
  @override
  FutureOr<void> getOrThrow(bool input) {
    return feature.setAudioMuted(input);
  }
}
