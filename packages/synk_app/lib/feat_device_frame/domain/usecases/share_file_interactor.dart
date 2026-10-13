import 'dart:async';

import 'package:synk/feat_device_frame/domain/models/dropped_file_outcome.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:use_in_case/use_in_case.dart';

class const ShareFileInteractor(final DeviceFrameRepository repository)
    implements ParameterizedResultInteractor<DeviceId, DroppedFileOutcome?> {
  @override
  FutureOr<DroppedFileOutcome?> getOrThrow(DeviceId input) {
    return repository.shareFile(input);
  }
}
