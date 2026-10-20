import 'dart:async';

import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_sidebar/domain/sidebar_feature.dart';
import 'package:use_in_case/use_in_case.dart';

class const DisconnectDeviceInteractor(final SidebarFeature feature)
    implements ParameterizedInteractor<PluggedDevice> {
  @override
  FutureOr<void> getOrThrow(PluggedDevice input) {
    return feature.disconnect(input);
  }
}
