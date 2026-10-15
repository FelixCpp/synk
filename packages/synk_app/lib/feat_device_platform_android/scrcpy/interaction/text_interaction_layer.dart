import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class TextInteractionLayer(final Socket interactionSocket) {
  static const scrcpyInjectTextEventId = 1;
  static const maxTextBytes = 300;
  static const _headerLength = 5;

  void injectText(String text) {
    final textBytes = utf8.encode(text);
    if (textBytes.length > maxTextBytes) {
      throw ArgumentError.value(
        text,
        'text',
        'is longer than the $maxTextBytes bytes scrcpy accepts',
      );
    }

    final message = Uint8List(_headerLength + textBytes.length)
      ..setRange(_headerLength, _headerLength + textBytes.length, textBytes);

    ByteData.sublistView(message)
      ..setUint8(0, scrcpyInjectTextEventId)
      ..setUint32(1, textBytes.length, .big);

    interactionSocket.add(message);
  }
}
