import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_platform_android/scrcpy/interaction/text_interaction_layer.dart';

void main() {
  late _RecordingSocket socket;
  late TextInteractionLayer layer;

  setUp(() {
    socket = _RecordingSocket();
    layer = TextInteractionLayer(socket);
  });

  test('sends the scrcpy INJECT_TEXT message with a four byte length', () {
    layer.injectText(':');

    expect(socket.writes.single, [
      TextInteractionLayer.scrcpyInjectTextEventId,
      0,
      0,
      0,
      1,
      0x3a,
    ]);
  });

  test('counts the length in UTF-8 bytes, not in characters', () {
    layer.injectText('ö');

    expect(socket.writes.single, [
      TextInteractionLayer.scrcpyInjectTextEventId,
      0,
      0,
      0,
      2,
      0xc3,
      0xb6,
    ]);
  });

  test('refuses text longer than the server reads', () {
    expect(
      () => layer.injectText('x' * (TextInteractionLayer.maxTextBytes + 1)),
      throwsArgumentError,
    );
    expect(socket.writes, isEmpty);
  });
}

class _RecordingSocket implements Socket {
  final writes = <List<int>>[];

  @override
  void add(List<int> data) => writes.add(data);

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}
