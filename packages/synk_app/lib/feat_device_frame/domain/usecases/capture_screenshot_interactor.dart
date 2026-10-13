import 'dart:async';

import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:use_in_case/use_in_case.dart';

class const CaptureScreenshotInteractor(final DeviceFrameRepository repository)
    implements ParameterizedInteractor<DeviceId> {
  @override
  FutureOr<void> getOrThrow(DeviceId input) {
    return repository.captureScreenshot(input);
  }
}
