import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

abstract final class AppShortcuts {
  static const openSettings = SingleActivator(
    LogicalKeyboardKey.comma,
    meta: true,
  );

  static const _all = [openSettings];

  /// Whether [event] is one of Synk's own shortcuts, which a mirrored device
  /// must not swallow.
  static bool owns(KeyEvent event) {
    return _all.any(
      (shortcut) => shortcut.accepts(event, HardwareKeyboard.instance),
    );
  }
}
