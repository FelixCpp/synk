import 'dart:async';

import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:use_in_case/use_in_case.dart';

class const SimulatePointerEventInteractor(
  final DeviceFrameRepository repository,
) implements ParameterizedInteractor<DevicePointerEvent> {
  @override
  FutureOr<void> getOrThrow(DevicePointerEvent input) {
    return repository.simulatePointerEvent(input);
  }
}
