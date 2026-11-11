import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/media_scan_interaction_layer.dart';

void main() {
  test('asks for a media scan with the scrcpy SCAN_FILE message', () {
    final socket = _RecordingSocket();
    const path = '/storage/emulated/0/Download/Ünterlagen.pdf';
    final pathBytes = utf8.encode(path);

    MediaScanInteractionLayer(socket).scanFile(path);

    expect(socket.writes.single, [
      MediaScanInteractionLayer.scrcpyScanFileEventId,
      0,
      0,
      0,
      pathBytes.length,
      ...pathBytes,
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
