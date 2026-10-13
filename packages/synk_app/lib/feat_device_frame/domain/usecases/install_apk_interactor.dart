import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_frame/domain/models/dropped_file_outcome.dart';
import 'package:use_in_case/use_in_case.dart';

class const InstallApkInteractor(final DeviceFrameRepository repository)
    implements ResultInteractor<DroppedFileOutcome?> {
  @override
  FutureOr<DroppedFileOutcome?> getOrThrow(Unit input) {
    return repository.installApk();
  }
}
