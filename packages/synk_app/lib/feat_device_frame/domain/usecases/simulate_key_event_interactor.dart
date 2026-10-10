import 'dart:async';

import 'package:synk/feat_device_agent/domain/models/device_key_event.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:use_in_case/use_in_case.dart';

typedef SimulateKeyEventInput = ({
  DeviceId deviceId,
  DeviceKeyEvent keyEvent,
});

class const SimulateKeyEventInteractor(final DeviceFrameRepository repository)
    implements ParameterizedInteractor<SimulateKeyEventInput> {
  @override
  FutureOr<void> getOrThrow(SimulateKeyEventInput input) async {
    return repository.simulateKeyEvent(input.deviceId, input.keyEvent);
  }
}
