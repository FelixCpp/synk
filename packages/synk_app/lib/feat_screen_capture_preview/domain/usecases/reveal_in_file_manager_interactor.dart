import 'dart:async';

import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_event.dart';
import 'package:synk/feat_screen_capture_preview/domain/screen_capture_preview_feature.dart';
import 'package:use_in_case/use_in_case.dart';

class const RevealInFileManagerInteractor(
  final ScreenCapturePreviewFeature feature,
) implements ParameterizedInteractor<ScreenCaptureEvent> {
  @override
  FutureOr<void> execute(ScreenCaptureEvent input) {
    return feature.revealInFileManager(input);
  }
}
