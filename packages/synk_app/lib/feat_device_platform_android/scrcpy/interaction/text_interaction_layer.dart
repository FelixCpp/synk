import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class TextInteractionLayer(final Socket interactionSocket) {
  static const scrcpyInjectTextEventId = 1;
  static const maxTextBytes = 300;
  static const _headerLength = 5;

  void injectText(String text) {
    for (final chunk in _chunksOf(text)) {
      _injectChunk(chunk);
    }
  }

  void _injectChunk(List<int> textBytes) {
    final message = Uint8List(_headerLength + textBytes.length)
      ..setRange(_headerLength, _headerLength + textBytes.length, textBytes);

    ByteData.sublistView(message)
      ..setUint8(0, scrcpyInjectTextEventId)
      ..setUint32(1, textBytes.length, .big);

    interactionSocket.add(message);
  }

  Iterable<List<int>> _chunksOf(String text) sync* {
    var chunk = <int>[];

    for (final rune in text.runes) {
      final bytes = utf8.encode(String.fromCharCode(rune));
      if (chunk.length + bytes.length > maxTextBytes) {
        yield chunk;
        chunk = <int>[];
      }
      chunk.addAll(bytes);
    }

    if (chunk.isNotEmpty) {
      yield chunk;
    }
  }
}
