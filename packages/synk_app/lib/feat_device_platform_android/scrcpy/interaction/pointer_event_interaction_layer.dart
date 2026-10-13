import 'dart:io';
import 'dart:typed_data';

import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_pointer_input.dart';

class PointerEventInteractionLayer(final Socket interactionSocket) {
  static const scrcpyPointerEventId = 2;
  static const scrcpyMousePointerId = -1; // scrcpy interprets -1 as mouse

  static const scrcpyFullPreasure = 0xfff;
  static const scrcpyNoPreasure = 0;

  static const androidPrimaryButton = 1;
  static const androidNoButton = 0;

  void simulatePointerEvent(
    ScrcpyPointerEvent event,
    DeviceScreenSize screenSize,
  ) {
    final scrcpyPointerTypeId = switch (event.type) {
      .down => 0,
      .up => 1,
      .move => 2,
    };

    final pointerX = _scale(event.normalizedPointerX, screenSize.width);
    final pointerY = _scale(event.normalizedPointerY, screenSize.height);

    final preasure = event.type == .up ? scrcpyNoPreasure : scrcpyFullPreasure;

    final changedButton = event.type == .move
        ? androidNoButton
        : androidPrimaryButton;

    final pressedButton = event.type == .up
        ? androidNoButton
        : androidPrimaryButton;

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

    interactionSocket.add(message.buffer.asUint8List());
  }

  int _scale(double normalized, int extent) {
    return (normalized.clamp(0.0, 1.0) * extent).round();
  }
}
