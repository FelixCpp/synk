import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_event.dart';

abstract interface class ScreenCapturePreviewRepository {
  Stream<ScreenCaptureEvent> observeEvents();
  Future<void> openInSystemViewer(ScreenCaptureEvent event);
}
