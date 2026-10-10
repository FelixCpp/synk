import 'package:synk/feat_device_agent/domain/models/device_key_event.dart';
import 'package:synk/feat_device_agent/domain/models/scrcpy_key_input.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('the scrcpy key code behind a logical key', () {
    test('is the android key code for that key', () {
      expect(scrcpyKeyCodeOf(LogicalKeyboardKey.keyC), 31);
      expect(scrcpyKeyCodeOf(LogicalKeyboardKey.keyV), 50);
      expect(scrcpyKeyCodeOf(LogicalKeyboardKey.keyA), 29);
    });

    test('does not exist for a key android has no code for', () {
      expect(scrcpyKeyCodeOf(const LogicalKeyboardKey(0x1ffffdead)), isNull);
    });
  });

  group('the android meta state behind a modifier set', () {
    test('is none without modifiers', () {
      expect(scrcpyMetaStateOf(const {}), ScrcpyKeyMetaState.none);
    });

    test('sets the side flag together with the generic one', () {
      final metaState = scrcpyMetaStateOf(const {DeviceKeyModifier.metaLeft});

      expect(metaState & ScrcpyKeyMetaState.metaLeftOn, isNonZero);
      expect(metaState & ScrcpyKeyMetaState.metaOn, isNonZero);
      expect(metaState & ScrcpyKeyMetaState.metaRightOn, isZero);
    });

    test('ors several modifiers into one state', () {
      final metaState = scrcpyMetaStateOf(const {
        DeviceKeyModifier.shiftRight,
        DeviceKeyModifier.controlLeft,
        DeviceKeyModifier.capsLock,
      });

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
      expect(scrcpyKeyEventTypeOf(.down), ScrcpyKeyEventType.down);
      expect(scrcpyKeyEventTypeOf(.repeat), ScrcpyKeyEventType.repeat);
      expect(scrcpyKeyEventTypeOf(.up), ScrcpyKeyEventType.up);
    });
  });
}
