import 'dart:async';

import 'package:synk/feat_device_platform/domain/models/device_key_event.dart';
import 'package:synk/feat_device_frame/domain/models/clipboard_sync_failure.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:use_in_case/use_in_case.dart';

typedef SimulateKeyEventInput = ({
  DeviceId deviceId,
  DeviceKeyEvent keyEvent,
});

class const SimulateKeyEventInteractor(final DeviceFrameRepository repository)
    implements
        ParameterizedResultInteractor<
          SimulateKeyEventInput,
          ClipboardSyncFailure?
        > {
  @override
  FutureOr<ClipboardSyncFailure?> getOrThrow(SimulateKeyEventInput input) {
    return repository.simulateKeyEvent(input.deviceId, input.keyEvent);
  }
}
