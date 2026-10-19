import 'package:flutter/services.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';

extension HostKeystroke on KeyEvent {
  /// This keystroke as the device understands it, or `null` for a kind of
  /// event no device has a phase for.
  ///
  /// [keyboard] supplies the modifiers, which a single event does not carry.
  DeviceKeyEvent? toDeviceKeyEvent(HardwareKeyboard keyboard) {
    final DeviceKeyEventType? type = switch (this) {
      KeyDownEvent() => .down,
      KeyRepeatEvent() => .repeat,
      KeyUpEvent() => .up,
      _ => null,
    };

    if (type == null) {
      return null;
    }

    return .new(
      key: logicalKey,
      physicalKey: physicalKey,
      type: type,
      modifiers: _pressedModifiers(keyboard),
      character: character,
    );
  }
}

Set<DeviceKeyModifier> _pressedModifiers(HardwareKeyboard keyboard) {
  return {
    for (final key in keyboard.logicalKeysPressed)
      ?switch (key) {
        LogicalKeyboardKey.shiftLeft => DeviceKeyModifier.shiftLeft,
        LogicalKeyboardKey.shiftRight => DeviceKeyModifier.shiftRight,
        LogicalKeyboardKey.controlLeft => DeviceKeyModifier.controlLeft,
        LogicalKeyboardKey.controlRight => DeviceKeyModifier.controlRight,
        LogicalKeyboardKey.altLeft => DeviceKeyModifier.altLeft,
        LogicalKeyboardKey.altRight => DeviceKeyModifier.altRight,
        LogicalKeyboardKey.metaLeft => DeviceKeyModifier.metaLeft,
        LogicalKeyboardKey.metaRight => DeviceKeyModifier.metaRight,
        _ => null,
      },
    for (final lockMode in keyboard.lockModesEnabled)
      switch (lockMode) {
        .capsLock => DeviceKeyModifier.capsLock,
        .numLock => DeviceKeyModifier.numLock,
        .scrollLock => DeviceKeyModifier.scrollLock,
      },
  };
}
