import 'dart:io';
import 'dart:typed_data';

import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_key_input.dart';

class KeyEventInteractionLayer(final Socket interactionSocket) {
  static const scrcpyInjectKeyEventId = 0;
  static const scrcpyKeyDownEventId = 0;
  static const scrcpyKeyUpEventId = 1;

  void simulateKeyEvent(ScrcpyKeyEvent event) {
    final int keyEventId = switch (event.type) {
      ScrcpyKeyEventType.down => scrcpyKeyDownEventId,
      ScrcpyKeyEventType.repeat => scrcpyKeyDownEventId,
      ScrcpyKeyEventType.up => scrcpyKeyUpEventId,
    };

    final bool isRepeated = event.type == .repeat;

    final message = ByteData(14)
      ..setUint8(0, scrcpyInjectKeyEventId)
      ..setUint8(1, keyEventId)
      ..setUint32(2, event.key, .big)
      ..setUint32(6, isRepeated ? 1 : 0, .big)
      ..setUint32(10, event.metaState, .big);

    interactionSocket.add(message.buffer.asUint8List());
  }
}
