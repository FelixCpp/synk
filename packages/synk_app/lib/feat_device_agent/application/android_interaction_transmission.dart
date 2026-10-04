import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_agent/domain/models/scrcpy_key_event.dart';
import 'package:synk/feat_device_agent/domain/models/scrcpy_pointer_action.dart';

mixin _InteractionTransmission {
  Socket get socket;

  void send(ByteData data) {
    socket.add(data.buffer.asUint8List());
  }
}

mixin _KeyEventSimulator on _InteractionTransmission {
  static const scrcpyInjectKeyEventId = 0;
  static const scrcpyKeyDownEventId = 0;
  static const scrcpyKeyUpEventId = 1;

  void simulateKeyEvent({
    required ScrcpyKeyCode keyCode,
    required ScrcpyKeyEventType type,
    required ScrcpyKeyMetaState metaState,
  }) {
    final int keyEventId = switch (type) {
      ScrcpyKeyEventType.down => scrcpyKeyDownEventId,
      ScrcpyKeyEventType.repeat => scrcpyKeyDownEventId,
      ScrcpyKeyEventType.up => scrcpyKeyUpEventId,
    };

    final bool isRepeated = type == .repeat;

    final message = ByteData(14)
      ..setUint8(0, scrcpyInjectKeyEventId)
      ..setUint8(1, keyEventId)
      ..setUint32(2, keyCode, .big)
      ..setUint32(6, isRepeated ? 1 : 0, .big)
      ..setUint32(10, metaState, .big);

    send(message);
  }
}

mixin _PointerEventSimulator on _InteractionTransmission {
  DeviceScreenSize get screenSize;

  static const scrcpyPointerEventId = 2;
  static const scrcpyMousePointerId = -1; // scrcpy interprets -1 as mouse

  static const scrcpyFullPreasure = 0xfff;
  static const scrcpyNoPreasure = 0;

  static const androidPrimaryButton = 1;
  static const androidNoButton = 0;

  void simulatePointerEvent({
    required ScrcpyPointerEventType type,
    required double normalizedPointerX,
    required double normalizedPointerY,
  }) {
    final scrcpyPointerTypeId = switch (type) {
      .down => 0,
      .up => 1,
      .move => 2,
    };

    final (pointerX, pointerY) = worldToScreen(
      normalizedPointerX,
      normalizedPointerY,
    );

    final preasure = type == .up ? scrcpyNoPreasure : scrcpyFullPreasure;
    final changedButton = type == .move
        ? androidNoButton
        : androidPrimaryButton;
    final pressedButton = type == .up ? androidNoButton : androidPrimaryButton;

    final message = ByteData(32)
      ..setUint8(0, scrcpyPointerEventId)
      ..setUint8(1, scrcpyPointerTypeId)
      ..setUint64(2, scrcpyMousePointerId, .big)
      ..setInt32(10, pointerX, .big)
      ..setInt32(14, pointerY, .big)
      ..setUint16(18, screenSize.width, .big)
      ..setUint16(20, screenSize.height, .big)
      ..setUint16(22, preasure, .big)
      ..setUint32(24, changedButton, .big)
      ..setUint32(28, pressedButton, .big);

    send(message);
  }

  (int, int) worldToScreen(double x, double y) {
    final touchX = x.clamp(0.0, 1.0);
    final touchY = y.clamp(0.0, 1.0);
    final scaledX = (touchX * screenSize.width).round();
    final scaledY = (touchY * screenSize.height).round();

    return (scaledX, scaledY);
  }
}

mixin _ClipboardEventSimulator on _InteractionTransmission {
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

    send(message);
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

    send(message);

    return completer.future.timeout(timeout);
  }

  void _listenForDeviceMessages() {
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
    final bytes = StreamQueue(socket.expand((chunk) => chunk));

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

class AndroidInteractionTransmission({
  @override required final Socket socket,
  @override required final DeviceScreenSize screenSize,
}) with
    _InteractionTransmission,
    _KeyEventSimulator,
    _PointerEventSimulator,
    _ClipboardEventSimulator {
  this {
    _listenForDeviceMessages();
  }

  Future<void> dispose() async {
    await socket.close();
  }
}
