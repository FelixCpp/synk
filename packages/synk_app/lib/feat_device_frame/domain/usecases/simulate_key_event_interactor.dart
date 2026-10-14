import 'dart:async';

import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_frame/domain/models/clipboard_sync_failure.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:use_in_case/use_in_case.dart';

class const SimulateKeyEventInteractor(final DeviceFrameRepository repository)
    implements
        ParameterizedResultInteractor<DeviceKeyEvent, ClipboardSyncFailure?> {
  @override
  FutureOr<ClipboardSyncFailure?> getOrThrow(DeviceKeyEvent input) {
    return repository.simulateKeyEvent(input);
  }
}
