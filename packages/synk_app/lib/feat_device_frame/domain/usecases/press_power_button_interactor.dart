import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const PressPowerButtonInteractor(final DeviceFrameRepository repository)
    implements Interactor {
  @override
  FutureOr<void> getOrThrow(Unit input) {
    return repository.pressPowerButton();
  }
}
