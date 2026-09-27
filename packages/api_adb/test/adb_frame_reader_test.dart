import 'dart:async';
import 'dart:convert';

import 'package:api_adb/adb/devices/adb_frame_reader.dart';
import 'package:test/test.dart';

List<int> frame(String payload) {
  final bytes = ascii.encode(payload);
  final length = bytes.length.toRadixString(16).padLeft(4, '0');
  return [...ascii.encode(length), ...bytes];
}

void main() {
  test('reads a single frame delivered in one chunk', () async {
    final source = Stream.fromIterable([frame('hello')]);
    final frames = await AdbFrameReader(source).frames().toList();

    expect(frames.map(ascii.decode), ['hello']);
  });

  test('reads multiple frames delivered in one chunk', () async {
    final source = Stream.fromIterable([
      [...frame('one'), ...frame('two')],
    ]);
    final frames = await AdbFrameReader(source).frames().toList();

    expect(frames.map(ascii.decode), ['one', 'two']);
  });

  test('reassembles a frame split across multiple chunks', () async {
    final bytes = frame('reassembled');
    final controller = StreamController<List<int>>();

    final result = AdbFrameReader(controller.stream).frames().toList();

    for (final byte in bytes) {
      controller.add([byte]);
    }
    await controller.close();

    expect((await result).map(ascii.decode), ['reassembled']);
  });

  test('throws a FormatException for a non-hex length header', () {
    final source = Stream.fromIterable([ascii.encode('xxxx')]);

    expect(
      AdbFrameReader(source).frames().toList,
      throwsA(isA<FormatException>()),
    );
  });
}
