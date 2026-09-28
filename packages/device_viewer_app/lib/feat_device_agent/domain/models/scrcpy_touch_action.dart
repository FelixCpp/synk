import 'package:freezed_annotation/freezed_annotation.dart';

part 'scrcpy_touch_action.freezed.dart';

enum ScrcpyPointerEventType {
  down,
  up,
  move,
}

@freezed
sealed class ScrcpyPointerEvent with _$ScrcpyPointerEvent {
  const factory ScrcpyPointerEvent({
    required ScrcpyPointerEventType type,
    required double normalizedPointerX,
    required double normalizedPointerY,
  }) = _ScrcpyPointerEvent;
}
