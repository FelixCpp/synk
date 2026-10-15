import 'package:flutter/services.dart';

/// The HID usage page every key of a computer keyboard lives on.
const _keyboardPage = 0x07;

/// The HID usage of [key] on the keyboard page, or `null` for a key that
/// lives on another page, like fn.
///
/// The usage names where the key sits, not what it types. iOS turns it into
/// a character with the keyboard layout set on the device, as it does for any
/// hardware keyboard. That is what lets `:` - shift and the period key on a
/// German layout - arrive as `:` on a device set to the same layout, where a
/// lookup by character found no key for it at all.
int? iosKeyUsageOf(PhysicalKeyboardKey key) {
  final usage = key.usbHidUsage;
  if (usage >> 16 != _keyboardPage) {
    return null;
  }

  return usage & 0xffff;
}
