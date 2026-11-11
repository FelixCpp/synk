import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/video_interaction_layer.dart';

void main() {
  test('asks for a fresh keyframe with the scrcpy RESET_VIDEO message', () {
    final socket = _RecordingSocket();

    VideoInteractionLayer(socket).resetVideo();

    expect(socket.writes.single, [
      VideoInteractionLayer.scrcpyResetVideoEventId,
    ]);
  });
}

class _RecordingSocket implements Socket {
  final writes = <List<int>>[];

  @override
  void add(List<int> data) => writes.add(data);

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}
