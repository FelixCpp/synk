import 'dart:async';

import 'package:synk/feat_device_frame/domain/device_frame_feature.dart';
import 'package:use_in_case/use_in_case.dart';

class const TypeTextInteractor(final DeviceFrameFeature feature)
    implements ParameterizedInteractor<String> {
  @override
  FutureOr<void> execute(String input) {
    return feature.typeText(input);
  }
}
