import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';

class ClipboardInteractionLayer(final Socket interactionSocket) {
  static const scrcpyGetClipboardEventId = 8;
  static const scrcpySetClipboardEventId = 9;
  static const scrcpyCopyKeyCopy = 1;

  static const scrcpyDeviceMsgClipboardId = 0;
  static const scrcpyDeviceMsgAckClipboardId = 1;

  Completer<String>? _pendingCopyRequest;

  void setClipboard({
    required String text,
  }) {
    final textBytes = utf8.encode(text);
    const headerLength = 14;

    final message = ByteData(headerLength + textBytes.length)
      ..setUint8(0, scrcpySetClipboardEventId)
      ..setUint64(1, 0, .big)
      ..setUint8(9, 1)
      ..setUint32(10, textBytes.length, .big);

    for (var i = 0; i < textBytes.length; ++i) {
      message.setUint8(headerLength + i, textBytes[i]);
    }

    interactionSocket.add(message.buffer.asUint8List());
  }

  Future<String> getClipboard({
    Duration timeout = const Duration(seconds: 3),
  }) {
    _pendingCopyRequest?.completeError(
      StateError('Superseded by a newer clipboard request.'),
    );

    final completer = Completer<String>();
    _pendingCopyRequest = completer;

    final message = ByteData(2)
      ..setUint8(0, scrcpyGetClipboardEventId)
      ..setUint8(1, scrcpyCopyKeyCopy);

    interactionSocket.add(message.buffer.asUint8List());
    return completer.future.timeout(timeout);
  }

  void listenForDeviceMessages() {
    unawaited(
      _readDeviceMessages().catchError((Object error, StackTrace stackTrace) {
        developer.log(
          'Interaction socket message reader stopped unexpectedly',
          name: 'AndroidInteractionTransmission',
          error: error,
          stackTrace: stackTrace,
        );
      }),
    );
  }

  Future<void> _readDeviceMessages() async {
    final bytes = StreamQueue(interactionSocket.expand((chunk) => chunk));

    while (true) {
      final header = await bytes.take(1);
      if (header.isEmpty) return;

      switch (header[0]) {
        case scrcpyDeviceMsgClipboardId:
          final lengthBytes = await bytes.take(4);
          if (lengthBytes.length < 4) return;

          final length = ByteData.sublistView(
            Uint8List.fromList(lengthBytes),
          ).getUint32(0, .big);

          final textBytes = await bytes.take(length);
          if (textBytes.length < length) return;

          _pendingCopyRequest?.complete(utf8.decode(textBytes));
          _pendingCopyRequest = null;

        case scrcpyDeviceMsgAckClipboardId:
          final sequenceBytes = await bytes.take(8);
          if (sequenceBytes.length < 8) return;

        default:
          return;
      }
    }
  }
}
