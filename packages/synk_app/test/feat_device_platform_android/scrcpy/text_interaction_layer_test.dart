import 'dart:convert';
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

  test('splits text longer than the server reads into several messages', () {
    layer.injectText('x' * (TextInteractionLayer.maxTextBytes * 2 + 1));

    expect(
      socket.writes.map((message) => message.length - 5),
      [TextInteractionLayer.maxTextBytes, TextInteractionLayer.maxTextBytes, 1],
    );
  });

  test('never cuts a character in half between two messages', () {
    final text = 'ö' * TextInteractionLayer.maxTextBytes;

    layer.injectText(text);

    final typed = socket.writes
        .map((message) => utf8.decode(message.sublist(5)))
        .join();
    expect(typed, text);
    expect(
      socket.writes.map((message) => message.length - 5),
      everyElement(lessThanOrEqualTo(TextInteractionLayer.maxTextBytes)),
    );
  });

  test('sends nothing for empty text', () {
    layer.injectText('');

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
