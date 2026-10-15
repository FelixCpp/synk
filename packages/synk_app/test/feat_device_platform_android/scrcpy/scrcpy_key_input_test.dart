import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform_android/scrcpy/scrcpy_key_input.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

ScrcpyKeyEvent? _scrcpyEventOf({
  LogicalKeyboardKey key = LogicalKeyboardKey.keyA,
  DeviceKeyEventType type = .down,
  Set<DeviceKeyModifier> modifiers = const {},
}) {
  return DeviceKeyEvent(
    key: key,
    physicalKey: PhysicalKeyboardKey.keyA,
    type: type,
    modifiers: modifiers,
  ).toScrcpyKeyEvent();
}

String? _scrcpyTextOf(
  String? character, {
  LogicalKeyboardKey key = LogicalKeyboardKey.keyA,
  DeviceKeyEventType type = .down,
  Set<DeviceKeyModifier> modifiers = const {},
}) {
  return DeviceKeyEvent(
    key: key,
    physicalKey: PhysicalKeyboardKey.keyA,
    type: type,
    modifiers: modifiers,
    character: character,
  ).toScrcpyText();
}

void main() {
  group('the scrcpy key code behind a logical key', () {
    test('is the android key code for that key', () {
      expect(_scrcpyEventOf(key: LogicalKeyboardKey.keyC)!.key, 31);
      expect(_scrcpyEventOf(key: LogicalKeyboardKey.keyV)!.key, 50);
      expect(_scrcpyEventOf(key: LogicalKeyboardKey.keyA)!.key, 29);
    });

    test('does not exist for a key android has no code for', () {
      expect(
        _scrcpyEventOf(key: const LogicalKeyboardKey(0x1ffffdead)),
        isNull,
      );
    });
  });

  group('the android meta state behind a modifier set', () {
    test('is none without modifiers', () {
      expect(_scrcpyEventOf()!.metaState, ScrcpyKeyMetaState.none);
    });

    test('sets the side flag together with the generic one', () {
      final metaState = _scrcpyEventOf(
        modifiers: const {DeviceKeyModifier.metaLeft},
      )!.metaState;

      expect(metaState & ScrcpyKeyMetaState.metaLeftOn, isNonZero);
      expect(metaState & ScrcpyKeyMetaState.metaOn, isNonZero);
      expect(metaState & ScrcpyKeyMetaState.metaRightOn, isZero);
    });

    test('ors several modifiers into one state', () {
      final metaState = _scrcpyEventOf(
        modifiers: const {
          DeviceKeyModifier.shiftRight,
          DeviceKeyModifier.controlLeft,
          DeviceKeyModifier.capsLock,
        },
      )!.metaState;

      expect(metaState & ScrcpyKeyMetaState.shiftRightOn, isNonZero);
      expect(metaState & ScrcpyKeyMetaState.shiftOn, isNonZero);
      expect(metaState & ScrcpyKeyMetaState.ctrlLeftOn, isNonZero);
      expect(metaState & ScrcpyKeyMetaState.ctrlOn, isNonZero);
      expect(metaState & ScrcpyKeyMetaState.capsLockOn, isNonZero);
      expect(metaState & ScrcpyKeyMetaState.altOn, isZero);
    });
  });

  group('the text scrcpy injects for a keystroke', () {
    test('is a symbol android has no key code for', () {
      // Shift and the period key on a German layout.
      expect(
        _scrcpyTextOf(
          ':',
          key: LogicalKeyboardKey.colon,
          modifiers: const {DeviceKeyModifier.shiftLeft},
        ),
        ':',
      );
    });

    test('is a letter outside the US alphabet', () {
      expect(_scrcpyTextOf('ö', key: const LogicalKeyboardKey(0xf6)), 'ö');
    });

    test('is what option typed on a mac', () {
      expect(
        _scrcpyTextOf(
          '@',
          key: LogicalKeyboardKey.keyL,
          modifiers: const {DeviceKeyModifier.altLeft},
        ),
        '@',
      );
    });

    test('is a symbol even where android has a key code for it', () {
      // The German `#` key is not where the US one is; its text is right on
      // any device layout, the key code only on a US one.
      expect(_scrcpyTextOf('#', key: LogicalKeyboardKey.numberSign), '#');
    });

    test('is typed again while the key repeats', () {
      expect(_scrcpyTextOf(':', type: .repeat), ':');
    });

    test('does not exist for letters, digits and space', () {
      expect(_scrcpyTextOf('a'), isNull);
      expect(_scrcpyTextOf('A'), isNull);
      expect(_scrcpyTextOf('7', key: LogicalKeyboardKey.digit7), isNull);
      expect(_scrcpyTextOf(' ', key: LogicalKeyboardKey.space), isNull);
    });

    test('does not exist for keys that type a control character', () {
      expect(_scrcpyTextOf('\r', key: LogicalKeyboardKey.enter), isNull);
      expect(_scrcpyTextOf('\t', key: LogicalKeyboardKey.tab), isNull);
      expect(_scrcpyTextOf('\x7f', key: LogicalKeyboardKey.backspace), isNull);
    });

    test('does not exist for a shortcut', () {
      expect(
        _scrcpyTextOf(
          '.',
          key: LogicalKeyboardKey.period,
          modifiers: const {DeviceKeyModifier.metaLeft},
        ),
        isNull,
      );
      expect(
        _scrcpyTextOf(
          ':',
          key: LogicalKeyboardKey.colon,
          modifiers: const {DeviceKeyModifier.controlLeft},
        ),
        isNull,
      );
    });

    test('does not exist for a release', () {
      expect(_scrcpyTextOf(':', type: .up), isNull);
    });
  });

  group('the scrcpy event type behind a device event type', () {
    test('keeps the three phases apart', () {
      expect(_scrcpyEventOf(type: .down)!.type, ScrcpyKeyEventType.down);
      expect(_scrcpyEventOf(type: .repeat)!.type, ScrcpyKeyEventType.repeat);
      expect(_scrcpyEventOf(type: .up)!.type, ScrcpyKeyEventType.up);
    });
  });
}
