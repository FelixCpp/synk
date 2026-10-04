import 'dart:async';

import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:use_in_case/use_in_case.dart';

typedef SetAudioMutedInput = ({DeviceId deviceId, bool muted});

class const SetAudioMutedInteractor(final DeviceFrameRepository repository)
    implements ParameterizedInteractor<SetAudioMutedInput> {
  @override
  FutureOr<void> getOrThrow(SetAudioMutedInput input) {
    return repository.setAudioMuted(input.deviceId, input.muted);
  }
}
