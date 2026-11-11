import 'dart:async';

import 'package:synk/feat_device_frame/domain/device_frame_feature.dart';
import 'package:use_in_case/use_in_case.dart';

class const RotateInteractor(final DeviceFrameFeature feature)
    implements Interactor {
  @override
  FutureOr<void> execute(NoInput input) {
    return feature.rotate();
  }
}
