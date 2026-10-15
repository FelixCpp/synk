import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';

part 'scrcpy_key_input.freezed.dart';

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

@freezed
sealed class ScrcpyKeyEvent with _$ScrcpyKeyEvent {
  const factory ScrcpyKeyEvent({
    required ScrcpyKeyCode key,
    required ScrcpyKeyEventType type,
    required ScrcpyKeyMetaState metaState,
  }) = _ScrcpyKeyEvent;
}

extension DeviceKeyEventToScrcpy on DeviceKeyEvent {
  ScrcpyKeyEvent? toScrcpyKeyEvent() {
    if (_scrcpyKeyCodeOf(key) case final key?) {
      return .new(
        key: key,
        type: _scrcpyKeyEventTypeOf(type),
        metaState: _scrcpyMetaStateOf(modifiers),
      );
    }

    return null;
  }
}

extension DeviceKeyEventToScrcpyText on DeviceKeyEvent {
  /// The text this keystroke types, for a keystroke scrcpy should inject as
  /// text rather than as a key code - the way scrcpy's own keyboard does.
  ///
  /// Android finds a key code by what a key means on a US keyboard. Letters,
  /// digits and space have one of their own and stay key codes, so they keep
  /// repeating and still work in games. Every other printable character is
  /// sent as the text the host's layout typed: `:` is shift and the period
  /// key on a German Mac, and no Android key code means `:`.
  ///
  /// Shortcuts held with control or meta stay key codes too: they are meant
  /// as commands, not as text.
  String? toScrcpyText() {
    final character = this.character;
    if (type == .up || character == null || _isShortcut) {
      return null;
    }

    if (!_isPrintable(character) || _hasOwnKeyCode.hasMatch(character)) {
      return null;
    }

    return character;
  }

  bool get _isShortcut => modifiers.any(
    (modifier) => switch (modifier) {
      .controlLeft || .controlRight || .metaLeft || .metaRight => true,
      _ => false,
    },
  );
}

final _hasOwnKeyCode = RegExp(r'^[a-zA-Z0-9 ]$');

/// Enter, tab, backspace and escape come with a control character of their
/// own; they are keys, not text.
bool _isPrintable(String text) {
  return text.isNotEmpty &&
      text.runes.every((rune) => rune >= 0x20 && rune != 0x7f);
}

final _scrcpyKeyCodeByLogicalKey = Map.fromEntries(
  kAndroidToLogicalKey.entries.map(
    (entry) => MapEntry(entry.value, ScrcpyKeyCode(entry.key)),
  ),
);

ScrcpyKeyCode? _scrcpyKeyCodeOf(LogicalKeyboardKey key) {
  return _scrcpyKeyCodeByLogicalKey[key];
}

ScrcpyKeyEventType _scrcpyKeyEventTypeOf(DeviceKeyEventType type) {
  return switch (type) {
    .down => .down,
    .repeat => .repeat,
    .up => .up,
  };
}

ScrcpyKeyMetaState _scrcpyMetaStateOf(Set<DeviceKeyModifier> modifiers) {
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
