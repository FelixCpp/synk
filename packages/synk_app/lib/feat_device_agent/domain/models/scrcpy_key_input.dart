import 'package:flutter/services.dart';
import 'package:synk/feat_device_agent/domain/models/device_key_event.dart';

extension type const ScrcpyKeyCode(int value) implements int {
  static const wakeup = ScrcpyKeyCode(224);

  static const home = ScrcpyKeyCode(3);
  static const back = ScrcpyKeyCode(4);
  static const appSwitch = ScrcpyKeyCode(187);
  static const power = ScrcpyKeyCode(26);
}

extension type const ScrcpyKeyMetaState(int value) implements int {
  static const none = ScrcpyKeyMetaState(0x00000000);
  static const shiftOn = ScrcpyKeyMetaState(0x00000001);
  static const altOn = ScrcpyKeyMetaState(0x00000002);
  static const altLeftOn = ScrcpyKeyMetaState(0x00000010);
  static const altRightOn = ScrcpyKeyMetaState(0x00000020);
  static const shiftLeftOn = ScrcpyKeyMetaState(0x00000040);
  static const shiftRightOn = ScrcpyKeyMetaState(0x00000080);
  static const ctrlOn = ScrcpyKeyMetaState(0x00001000);
  static const ctrlLeftOn = ScrcpyKeyMetaState(0x00002000);
  static const ctrlRightOn = ScrcpyKeyMetaState(0x00004000);
  static const metaOn = ScrcpyKeyMetaState(0x00010000);
  static const metaLeftOn = ScrcpyKeyMetaState(0x00020000);
  static const metaRightOn = ScrcpyKeyMetaState(0x00040000);
  static const capsLockOn = ScrcpyKeyMetaState(0x00100000);
  static const numLockOn = ScrcpyKeyMetaState(0x00200000);
  static const scrollLockOn = ScrcpyKeyMetaState(0x00400000);
}

enum ScrcpyKeyEventType {
  down,
  repeat,
  up,
}

final _scrcpyKeyCodeByLogicalKey = Map.fromEntries(
  kAndroidToLogicalKey.entries.map(
    (entry) => MapEntry(entry.value, ScrcpyKeyCode(entry.key)),
  ),
);

ScrcpyKeyCode? scrcpyKeyCodeOf(LogicalKeyboardKey key) {
  return _scrcpyKeyCodeByLogicalKey[key];
}

ScrcpyKeyEventType scrcpyKeyEventTypeOf(DeviceKeyEventType type) {
  return switch (type) {
    .down => .down,
    .repeat => .repeat,
    .up => .up,
  };
}

ScrcpyKeyMetaState scrcpyMetaStateOf(Set<DeviceKeyModifier> modifiers) {
  var metaState = ScrcpyKeyMetaState.none.value;

  for (final modifier in modifiers) {
    metaState |= switch (modifier) {
      .shiftLeft => ScrcpyKeyMetaState.shiftLeftOn | ScrcpyKeyMetaState.shiftOn,
      .shiftRight =>
        ScrcpyKeyMetaState.shiftRightOn | ScrcpyKeyMetaState.shiftOn,
      .controlLeft => ScrcpyKeyMetaState.ctrlLeftOn | ScrcpyKeyMetaState.ctrlOn,
      .controlRight =>
        ScrcpyKeyMetaState.ctrlRightOn | ScrcpyKeyMetaState.ctrlOn,
      .altLeft => ScrcpyKeyMetaState.altLeftOn | ScrcpyKeyMetaState.altOn,
      .altRight => ScrcpyKeyMetaState.altRightOn | ScrcpyKeyMetaState.altOn,
      .metaLeft => ScrcpyKeyMetaState.metaLeftOn | ScrcpyKeyMetaState.metaOn,
      .metaRight => ScrcpyKeyMetaState.metaRightOn | ScrcpyKeyMetaState.metaOn,
      .capsLock => ScrcpyKeyMetaState.capsLockOn,
      .numLock => ScrcpyKeyMetaState.numLockOn,
      .scrollLock => ScrcpyKeyMetaState.scrollLockOn,
    };
  }

  return ScrcpyKeyMetaState(metaState);
}
