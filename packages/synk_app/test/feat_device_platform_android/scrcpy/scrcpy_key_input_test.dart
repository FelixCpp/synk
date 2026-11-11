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

    test('does not exist for command, which the mac keeps for itself', () {
      for (final key in [
        LogicalKeyboardKey.metaLeft,
        LogicalKeyboardKey.metaRight,
      ]) {
        for (final DeviceKeyEventType type in [.down, .repeat, .up]) {
          expect(_scrcpyEventOf(key: key, type: type), isNull);
        }
      }
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
        modifiers: const {DeviceKeyModifier.shiftLeft},
      )!.metaState;

      expect(metaState & ScrcpyKeyMetaState.shiftLeftOn, isNonZero);
      expect(metaState & ScrcpyKeyMetaState.shiftOn, isNonZero);
      expect(metaState & ScrcpyKeyMetaState.shiftRightOn, isZero);
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

  group('a mac shortcut on android', () {
    const command = {DeviceKeyModifier.metaLeft};
    const option = {DeviceKeyModifier.altLeft};

    bool holds(ScrcpyKeyEvent event, ScrcpyKeyMetaState flag) {
      return event.metaState & flag != 0;
    }

    test('turns command into control', () {
      for (final key in [
        LogicalKeyboardKey.keyA,
        LogicalKeyboardKey.keyZ,
        LogicalKeyboardKey.keyX,
      ]) {
        final event = _scrcpyEventOf(key: key, modifiers: command)!;

        expect(holds(event, ScrcpyKeyMetaState.ctrlLeftOn), isTrue);
        expect(holds(event, ScrcpyKeyMetaState.ctrlOn), isTrue);
        expect(holds(event, ScrcpyKeyMetaState.metaOn), isFalse);
      }
    });

    test('keeps shift, for redo and for selecting', () {
      final event = _scrcpyEventOf(
        key: LogicalKeyboardKey.keyZ,
        modifiers: const {...command, DeviceKeyModifier.shiftLeft},
      )!;

      expect(holds(event, ScrcpyKeyMetaState.ctrlOn), isTrue);
      expect(holds(event, ScrcpyKeyMetaState.shiftOn), isTrue);
    });

    test('jumps to the start and end of the line with the arrows', () {
      final start = _scrcpyEventOf(
        key: LogicalKeyboardKey.arrowLeft,
        modifiers: command,
      )!;
      final end = _scrcpyEventOf(
        key: LogicalKeyboardKey.arrowRight,
        modifiers: command,
      )!;

      expect(start.key, 122);
      expect(end.key, 123);
      expect(start.metaState, ScrcpyKeyMetaState.none);
      expect(end.metaState, ScrcpyKeyMetaState.none);
    });

    test('jumps to the start and end of the text with up and down', () {
      final start = _scrcpyEventOf(
        key: LogicalKeyboardKey.arrowUp,
        modifiers: command,
      )!;
      final end = _scrcpyEventOf(
        key: LogicalKeyboardKey.arrowDown,
        modifiers: command,
      )!;

      expect(start.key, 122);
      expect(end.key, 123);
      expect(holds(start, ScrcpyKeyMetaState.ctrlOn), isTrue);
      expect(holds(end, ScrcpyKeyMetaState.ctrlOn), isTrue);
    });

    test('deletes back to the start of the line', () {
      final event = _scrcpyEventOf(
        key: LogicalKeyboardKey.backspace,
        modifiers: command,
      )!;

      expect(event.key, 67);
      expect(holds(event, ScrcpyKeyMetaState.altOn), isTrue);
      expect(holds(event, ScrcpyKeyMetaState.metaOn), isFalse);
    });

    test('moves and deletes word by word with option', () {
      for (final key in [
        LogicalKeyboardKey.arrowLeft,
        LogicalKeyboardKey.arrowRight,
        LogicalKeyboardKey.backspace,
        LogicalKeyboardKey.delete,
      ]) {
        final event = _scrcpyEventOf(key: key, modifiers: option)!;

        expect(holds(event, ScrcpyKeyMetaState.ctrlOn), isTrue);
        expect(holds(event, ScrcpyKeyMetaState.altOn), isFalse);
      }
    });

    test('leaves option alone on other keys', () {
      final event = _scrcpyEventOf(
        key: LogicalKeyboardKey.arrowUp,
        modifiers: option,
      )!;

      expect(holds(event, ScrcpyKeyMetaState.altOn), isTrue);
      expect(holds(event, ScrcpyKeyMetaState.ctrlOn), isFalse);
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
