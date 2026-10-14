import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:synk/feat_device_frame/domain/models/file_transfer_outcome.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const SendPickedApkInteractor(final DeviceFrameRepository repository)
    implements ResultInteractor<FileTransferOutcome?> {
  @override
  FutureOr<FileTransferOutcome?> getOrThrow(Unit input) {
    return repository.sendPickedApk();
  }
}
