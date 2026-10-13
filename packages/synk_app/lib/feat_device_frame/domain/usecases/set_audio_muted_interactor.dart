import 'dart:async';

import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const SetAudioMutedInteractor(final DeviceFrameRepository repository)
    implements ParameterizedInteractor<bool> {
  @override
  FutureOr<void> getOrThrow(bool input) {
    return repository.setAudioMuted(input);
  }
}
