import 'dart:async';

import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:use_in_case/use_in_case.dart';

class const SimulatePinchEventInteractor(
  final DeviceFrameRepository repository,
) implements ParameterizedInteractor<PinchEvent> {
  @override
  FutureOr<void> getOrThrow(PinchEvent input) {
    return repository.simulatePinchEvent(input);
  }
}
