import 'dart:async';

import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:use_in_case/use_in_case.dart';

class const StartRecordingInteractor(final DeviceFrameRepository repository)
    implements ParameterizedResultInteractor<DeviceId, bool> {
  @override
  FutureOr<bool> getOrThrow(DeviceId input) {
    return repository.startRecording(input);
  }
}
