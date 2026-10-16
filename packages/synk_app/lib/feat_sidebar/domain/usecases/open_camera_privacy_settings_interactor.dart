import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:synk/feat_screen_capture_preview/application/system_file_opener.dart';
import 'package:use_in_case/use_in_case.dart';

class const OpenCameraPrivacySettingsInteractor(final SystemFileOpener opener)
    implements Interactor {
  static const _cameraPrivacySettings =
      'x-apple.systempreferences:com.apple.preference.security?Privacy_Camera';

  @override
  FutureOr<void> getOrThrow(Unit input) {
    return opener.open(_cameraPrivacySettings);
  }
}
