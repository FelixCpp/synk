import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

abstract final class AppShortcuts {
  static const openSettings = SingleActivator(
    LogicalKeyboardKey.comma,
    meta: true,
  );

  static const _all = [openSettings];

  static bool owns(KeyEvent event) {
    final keyboard = HardwareKeyboard.instance;

    return _all.any(
      (shortcut) =>
          event.logicalKey == shortcut.trigger &&
          keyboard.isMetaPressed == shortcut.meta &&
          keyboard.isControlPressed == shortcut.control &&
          keyboard.isAltPressed == shortcut.alt &&
          keyboard.isShiftPressed == shortcut.shift,
    );
  }
}
