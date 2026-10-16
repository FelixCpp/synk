import 'dart:async';

import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const SetAudioVolumeInteractor(final DeviceFrameRepository repository)
    implements ParameterizedInteractor<double> {
  @override
  FutureOr<void> getOrThrow(double input) {
    return repository.setAudioVolume(input);
  }
}
