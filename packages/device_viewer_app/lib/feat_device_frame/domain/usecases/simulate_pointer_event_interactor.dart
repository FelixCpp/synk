import 'dart:async';

import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_pointer_action.dart';
import 'package:device_viewer/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';
import 'package:use_in_case/use_in_case.dart';

typedef SimulatePointerEventInput = ({
  DeviceId deviceId,
  ScrcpyPointerEvent pointerEvent,
});

class const SimulatePointerEventInteractor(
  final DeviceFrameRepository repository,
) implements ParameterizedInteractor<SimulatePointerEventInput> {
  @override
  FutureOr<void> getOrThrow(SimulatePointerEventInput input) async {
    return repository.simulatePointerEvent(input.deviceId, input.pointerEvent);
  }
}
