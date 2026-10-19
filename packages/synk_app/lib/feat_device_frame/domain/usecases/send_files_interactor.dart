import 'dart:async';

import 'package:synk/feat_device_frame/domain/device_frame_feature.dart';
import 'package:synk/feat_device_frame/domain/models/file_transfer_outcome.dart';
import 'package:use_in_case/use_in_case.dart';

class const SendFilesInteractor(final DeviceFrameFeature feature)
    implements
        ParameterizedResultInteractor<List<String>, List<FileTransferOutcome>> {
  @override
  FutureOr<List<FileTransferOutcome>> getOrThrow(List<String> input) {
    return feature.sendFiles(input);
  }
}
