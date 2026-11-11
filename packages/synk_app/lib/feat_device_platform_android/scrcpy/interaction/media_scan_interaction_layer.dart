import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class MediaScanInteractionLayer(final Socket interactionSocket) {
  static const scrcpyScanFileEventId = 22;
  static const _headerLength = 5;

  void scanFile(String remoteFilepath) {
    final pathBytes = utf8.encode(remoteFilepath);
    final message = Uint8List(_headerLength + pathBytes.length)
      ..setRange(_headerLength, _headerLength + pathBytes.length, pathBytes);

    ByteData.sublistView(message)
      ..setUint8(0, scrcpyScanFileEventId)
      ..setUint32(1, pathBytes.length, .big);

    interactionSocket.add(message);
  }
}
