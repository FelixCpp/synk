import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_key_event.freezed.dart';

enum DeviceKeyEventType {
  down,
  repeat,
  up,
}

enum DeviceKeyModifier {
  shiftLeft,
  shiftRight,
  controlLeft,
  controlRight,
  altLeft,
  altRight,
  metaLeft,
  metaRight,
  capsLock,
  numLock,
  scrollLock,
}

@freezed
sealed class DeviceKeyEvent with _$DeviceKeyEvent {
  const factory DeviceKeyEvent({
    required LogicalKeyboardKey key,
    required DeviceKeyEventType type,
    required Set<DeviceKeyModifier> modifiers,
  }) = _DeviceKeyEvent;
}

extension DeviceKeyEventModifiers on DeviceKeyEvent {
  bool get isMetaPressed =>
      modifiers.contains(DeviceKeyModifier.metaLeft) ||
      modifiers.contains(DeviceKeyModifier.metaRight);
}
