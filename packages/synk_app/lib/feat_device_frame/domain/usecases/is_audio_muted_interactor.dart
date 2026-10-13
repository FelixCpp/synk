import 'dart:async';

import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:use_in_case/use_in_case.dart';

class const IsAudioMutedInteractor(final DeviceFrameRepository repository)
    implements ParameterizedResultInteractor<DeviceId, bool> {
  @override
  FutureOr<bool> getOrThrow(DeviceId input) {
    return repository.isAudioMuted(input);
  }
}
