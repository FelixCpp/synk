import 'dart:async';

import 'package:synk/feat_device_frame/domain/models/control_button_type.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:use_in_case/use_in_case.dart';

typedef SimulateControlButtonEventInput = ({
  DeviceId deviceId,
  ControlButtonType type,
});

class const SimulateControlButtonEventInteractor(
  final DeviceFrameRepository repository,
) implements ParameterizedInteractor<SimulateControlButtonEventInput> {
  @override
  FutureOr<void> getOrThrow(SimulateControlButtonEventInput input) async {
    return repository.simulateControlButtonEvent(
      input.deviceId,
      input.type,
    );
  }
}
