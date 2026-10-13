import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_device_platform/domain/models/device_pointer_event.dart';

part 'scrcpy_pointer_input.freezed.dart';

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

extension DevicePointerEventToScrcpy on DevicePointerEvent {
  ScrcpyPointerEvent toScrcpyPointerEvent() {
    return .new(
      type: switch (type) {
        .down => .down,
        .up => .up,
        .move => .move,
      },
      normalizedPointerX: normalizedPointerX,
      normalizedPointerY: normalizedPointerY,
    );
  }
}
