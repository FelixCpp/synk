import 'package:synk/feat_device_agent/domain/models/ios_key_input.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('the HID usage code behind a logical key', () {
    test('is the keyboard page code for a letter', () {
      expect(iosKeyUsageOf(LogicalKeyboardKey.keyA), 0x04);
      expect(iosKeyUsageOf(LogicalKeyboardKey.keyZ), 0x1d);
    });

    test('runs one to nine before zero, as the HID tables do', () {
      expect(iosKeyUsageOf(LogicalKeyboardKey.digit1), 0x1e);
      expect(iosKeyUsageOf(LogicalKeyboardKey.digit9), 0x26);
      expect(iosKeyUsageOf(LogicalKeyboardKey.digit0), 0x27);
    });

    test('covers the keys that carry an edit, not a character', () {
      expect(iosKeyUsageOf(LogicalKeyboardKey.enter), 0x28);
      expect(iosKeyUsageOf(LogicalKeyboardKey.backspace), 0x2a);
      expect(iosKeyUsageOf(LogicalKeyboardKey.space), 0x2c);
      expect(iosKeyUsageOf(LogicalKeyboardKey.arrowLeft), 0x50);
    });

    test('maps the modifiers as keys of their own', () {
      expect(iosKeyUsageOf(LogicalKeyboardKey.shiftLeft), 0xe1);
      expect(iosKeyUsageOf(LogicalKeyboardKey.metaLeft), 0xe3);
      expect(iosKeyUsageOf(LogicalKeyboardKey.shiftRight), 0xe5);
    });

    test('does not exist for a key the keyboard page has no code for', () {
      expect(iosKeyUsageOf(LogicalKeyboardKey.gameButtonA), isNull);
      expect(iosKeyUsageOf(const LogicalKeyboardKey(0x1ffffdead)), isNull);
    });
  });
}
