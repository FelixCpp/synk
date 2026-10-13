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
    type: type,
    modifiers: modifiers,
  ).toScrcpyKeyEvent();
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

  group('the scrcpy event type behind a device event type', () {
    test('keeps the three phases apart', () {
      expect(_scrcpyEventOf(type: .down)!.type, ScrcpyKeyEventType.down);
      expect(_scrcpyEventOf(type: .repeat)!.type, ScrcpyKeyEventType.repeat);
      expect(_scrcpyEventOf(type: .up)!.type, ScrcpyKeyEventType.up);
    });
  });
}
