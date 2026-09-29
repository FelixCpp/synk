import 'package:freezed_annotation/freezed_annotation.dart';

part 'scrcpy_key_event.freezed.dart';

extension type const ScrcpyKeyCode(int value) implements int {
  static const wakeup = ScrcpyKeyCode(224);
  static const copy = ScrcpyKeyCode(31);
  static const paste = ScrcpyKeyCode(50);
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
    required ScrcpyKeyCode keyCode,
    required ScrcpyKeyMetaState metaState,
    required ScrcpyKeyEventType type,
  }) = _ScrcpyKeyEvent;
}
