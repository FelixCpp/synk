import 'dart:async';

import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_event.dart';
import 'package:synk/feat_screen_capture_preview/domain/repositories/screen_capture_preview_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const OpenInSystemViewerInteractor(
  final ScreenCapturePreviewRepository repository,
) implements ParameterizedInteractor<ScreenCaptureEvent> {
  @override
  FutureOr<void> getOrThrow(ScreenCaptureEvent input) {
    return repository.openInSystemViewer(input);
  }
}
