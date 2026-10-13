import 'dart:async';

import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/domain/models/device_navigation.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:use_in_case/use_in_case.dart';

typedef NavigateInput = ({
  DeviceId deviceId,
  DeviceNavigation navigation,
});

class const NavigateInteractor(final DeviceFrameRepository repository)
    implements ParameterizedInteractor<NavigateInput> {
  @override
  FutureOr<void> getOrThrow(NavigateInput input) {
    return repository.navigate(input.deviceId, input.navigation);
  }
}
