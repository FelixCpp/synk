import 'dart:async';

import 'package:synk/feat_device_frame/domain/device_frame_feature.dart';
import 'package:use_in_case/use_in_case.dart';

class const ReleasePressedKeysInteractor(final DeviceFrameFeature feature)
    implements Interactor {
  @override
  FutureOr<void> execute(NoInput input) {
    return feature.releasePressedKeys();
  }
}
