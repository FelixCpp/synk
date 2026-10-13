import 'dart:async';

import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_frame/domain/models/dropped_file_outcome.dart';
import 'package:use_in_case/use_in_case.dart';

class const HandleDroppedFilesInteractor(final DeviceFrameRepository repository)
    implements
        ParameterizedResultInteractor<List<String>, List<DroppedFileOutcome>> {
  @override
  FutureOr<List<DroppedFileOutcome>> getOrThrow(List<String> input) {
    return repository.handleDroppedFiles(input);
  }
}
