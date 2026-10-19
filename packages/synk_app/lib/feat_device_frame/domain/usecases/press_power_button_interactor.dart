import 'dart:async';

import 'package:synk/feat_device_frame/domain/device_frame_feature.dart';
import 'package:dartz/dartz.dart';
import 'package:use_in_case/use_in_case.dart';

class const PressPowerButtonInteractor(final DeviceFrameFeature feature)
    implements Interactor {
  @override
  FutureOr<void> getOrThrow(Unit input) {
    return feature.pressPowerButton();
  }
}
