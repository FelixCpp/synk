import 'dart:async';

import 'package:synk/feat_device_agent/domain/models/interaction_agent.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
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
