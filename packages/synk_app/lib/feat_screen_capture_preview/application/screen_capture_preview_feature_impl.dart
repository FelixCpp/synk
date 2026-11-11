import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_event.dart';
import 'package:synk/feat_screen_capture_preview/application/system_file_opener.dart';
import 'package:synk/feat_screen_capture_preview/domain/screen_capture_preview_feature.dart';

class const ScreenCapturePreviewFeatureImpl({
  required final ScreenCaptureEventChannel captures,
  required final SystemFileOpener fileOpener,
}) implements ScreenCapturePreviewFeature {
  @override
  Stream<ScreenCaptureEvent> observeCaptures() => captures.observeEvents();

  @override
  Future<void> openInSystemViewer(ScreenCaptureEvent capture) {
    return fileOpener.open(capture.filepath);
  }

  @override
  Future<void> revealInFileManager(ScreenCaptureEvent capture) {
    return fileOpener.reveal(capture.filepath);
  }

  @override
  Future<void> moveToTrash(ScreenCaptureEvent capture) {
    return fileOpener.moveToTrash(capture.filepath);
  }
}
