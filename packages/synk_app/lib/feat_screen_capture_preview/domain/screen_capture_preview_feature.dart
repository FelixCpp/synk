import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_event.dart';

/// What Synk can do with the pile of captures in the canvas corner.
abstract interface class ScreenCapturePreviewFeature {
  Stream<ScreenCaptureEvent> observeCaptures();
  Future<void> openInSystemViewer(ScreenCaptureEvent capture);
}
