import 'dart:io';
import 'dart:typed_data';

import 'package:device_viewer/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_key_action.dart';
import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_touch_action.dart';

class const AndroidInteractionTransmission({
  required final Socket socket,
  required final DeviceScreenSize screenSize,
}) {
  static const _typeInjectKeyEvent = 0;
  static const _typeInjectTouchEvent = 2;

  static const _pointerIdMouse = -1; // scrcpy POINTER_ID_MOUSE = UINT64_MAX
  static const _buttonPrimary = 1; // AMOTION_EVENT_BUTTON_PRIMARY

  static const _keyActionDown = 0;
  static const _keyActionUp = 1;

  Future<void> dispose() async {
    await socket.close();
  }

  (int, int) worldToScreen(double x, double y) {
    final touchX = x.clamp(0.0, 1.0);
    final touchY = y.clamp(0.0, 1.0);
    final scaledX = (touchX * screenSize.width).round();
    final scaledY = (touchY * screenSize.height).round();

    return (scaledX, scaledY);
  }

  void injectKey(ScrcpyKeyAction action) {
    final (actionId, repeat) = action.map(
      down: (_) => (_keyActionDown, 0),
      repeat: (event) => (_keyActionDown, event.repeat),
      up: (_) => (_keyActionUp, 0),
    );

    final message = ByteData(14)
      ..setUint8(0, _typeInjectKeyEvent)
      ..setUint8(1, actionId)
      ..setUint32(2, action.keyCode, .big)
      ..setUint32(6, repeat, .big)
      ..setUint32(10, action.metaState, .big);

    socket.add(message.buffer.asUint8List());
  }

  void injectTouch(ScrcpyTouchAction action) {
    final touchId = action.id;
    final (touchX, touchY) = worldToScreen(
      action.normalizedTouchX,
      action.normalizedTouchY,
    );

    final isUp = touchId == .up;
    final isMove = touchId == .move;

    final message = ByteData(32)
      ..setUint8(0, _typeInjectTouchEvent)
      ..setUint8(1, touchId.wireValue)
      ..setUint64(2, _pointerIdMouse, .big)
      ..setInt32(10, touchX, .big)
      ..setInt32(14, touchY, .big)
      ..setUint16(18, screenSize.width, .big)
      ..setUint16(20, screenSize.height, .big)
      ..setUint16(22, isUp ? 0 : 0xffff, .big)
      ..setUint32(24, isMove ? 0 : _buttonPrimary, .big)
      ..setUint32(28, isUp ? 0 : _buttonPrimary, .big);

    socket.add(message.buffer.asUint8List());
  }
}
