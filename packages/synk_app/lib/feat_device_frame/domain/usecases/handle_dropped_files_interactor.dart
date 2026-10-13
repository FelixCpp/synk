import 'dart:async';

import 'package:synk/feat_device_frame/domain/models/dropped_file_outcome.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:use_in_case/use_in_case.dart';

typedef HandleDroppedFilesInput = ({
  DeviceId deviceId,
  List<String> filepaths,
});

class const HandleDroppedFilesInteractor(final DeviceFrameRepository repository)
    implements
        ParameterizedResultInteractor<
          HandleDroppedFilesInput,
          List<DroppedFileOutcome>
        > {
  @override
  FutureOr<List<DroppedFileOutcome>> getOrThrow(
    HandleDroppedFilesInput input,
  ) {
    return repository.handleDroppedFiles(input.deviceId, input.filepaths);
  }
}
