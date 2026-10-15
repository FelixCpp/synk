import 'package:synk/feat_device_platform_ios/hid/ios_key_input.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('the HID usage code behind a physical key', () {
    test('is the keyboard page code for a letter', () {
      expect(iosKeyUsageOf(PhysicalKeyboardKey.keyA), 0x04);
      expect(iosKeyUsageOf(PhysicalKeyboardKey.keyZ), 0x1d);
    });

    test('runs one to nine before zero, as the HID tables do', () {
      expect(iosKeyUsageOf(PhysicalKeyboardKey.digit1), 0x1e);
      expect(iosKeyUsageOf(PhysicalKeyboardKey.digit9), 0x26);
      expect(iosKeyUsageOf(PhysicalKeyboardKey.digit0), 0x27);
    });

    test('covers the keys that carry an edit, not a character', () {
      expect(iosKeyUsageOf(PhysicalKeyboardKey.enter), 0x28);
      expect(iosKeyUsageOf(PhysicalKeyboardKey.backspace), 0x2a);
      expect(iosKeyUsageOf(PhysicalKeyboardKey.space), 0x2c);
      expect(iosKeyUsageOf(PhysicalKeyboardKey.arrowLeft), 0x50);
    });

    test('covers the symbol keys whatever they type on the host', () {
      expect(iosKeyUsageOf(PhysicalKeyboardKey.period), 0x37);
      expect(iosKeyUsageOf(PhysicalKeyboardKey.semicolon), 0x33);
      // The extra key left of Z on ISO keyboards: `<` on a German one.
      expect(iosKeyUsageOf(PhysicalKeyboardKey.intlBackslash), 0x64);
    });

    test('maps the modifiers as keys of their own', () {
      expect(iosKeyUsageOf(PhysicalKeyboardKey.shiftLeft), 0xe1);
      expect(iosKeyUsageOf(PhysicalKeyboardKey.metaLeft), 0xe3);
      expect(iosKeyUsageOf(PhysicalKeyboardKey.shiftRight), 0xe5);
    });

    test('does not exist for a key off the keyboard page', () {
      expect(iosKeyUsageOf(PhysicalKeyboardKey.fn), isNull);
      expect(iosKeyUsageOf(PhysicalKeyboardKey.mediaPlayPause), isNull);
    });
  });
}
