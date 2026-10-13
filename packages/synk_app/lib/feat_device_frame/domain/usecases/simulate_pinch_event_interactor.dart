import 'dart:async';

import 'package:synk/feat_device_platform/domain/models/pinch_event.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:use_in_case/use_in_case.dart';

typedef SimulatePinchEventInput = ({
  DeviceId deviceId,
  PinchEvent pinchEvent,
});

class const SimulatePinchEventInteractor(
  final DeviceFrameRepository repository,
) implements ParameterizedInteractor<SimulatePinchEventInput> {
  @override
  FutureOr<void> getOrThrow(SimulatePinchEventInput input) async {
    return repository.simulatePinchEvent(input.deviceId, input.pinchEvent);
  }
}
