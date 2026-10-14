import 'dart:async';

import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_event.dart';

class ScreenCaptureEventChannel {
  final _controller = StreamController<ScreenCaptureEvent>.broadcast();

  Future<void> dispose() async {
    await _controller.close();
  }

  void submit(ScreenCaptureEvent event) {
    _controller.add(event);
  }

  Stream<ScreenCaptureEvent> observeEvents() {
    return _controller.stream;
  }
}
