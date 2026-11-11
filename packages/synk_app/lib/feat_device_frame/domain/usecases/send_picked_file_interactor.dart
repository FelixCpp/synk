import 'dart:async';

import 'package:synk/feat_device_frame/domain/device_frame_feature.dart';
import 'package:synk/feat_device_frame/domain/models/file_transfer_outcome.dart';
import 'package:use_in_case/use_in_case.dart';

class const SendPickedFileInteractor(final DeviceFrameFeature feature)
    implements ResultInteractor<FileTransferOutcome?> {
  @override
  FutureOr<FileTransferOutcome?> execute(NoInput input) {
    return feature.sendPickedFile();
  }
}
