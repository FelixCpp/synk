import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_event.dart';
import 'package:synk/feat_screen_capture_preview/application/system_file_opener.dart';
import 'package:synk/feat_screen_capture_preview/domain/repositories/screen_capture_preview_repository.dart';

class const ScreenCapturePreviewRepositoryImpl(
  final ScreenCaptureEventChannel channel,
  final SystemFileOpener fileOpener,
) implements ScreenCapturePreviewRepository {
  @override
  Stream<ScreenCaptureEvent> observeEvents() {
    return channel.observeEvents();
  }

  @override
  Future<void> openInSystemViewer(ScreenCaptureEvent event) {
    return fileOpener.open(event.filepath);
  }
}
