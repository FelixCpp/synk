import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_pointer_event.freezed.dart';

enum DevicePointerEventType {
  down,
  up,
  move,
}

@freezed
sealed class DevicePointerEvent with _$DevicePointerEvent {
  const factory DevicePointerEvent({
    required DevicePointerEventType type,
    required double normalizedPointerX,
    required double normalizedPointerY,
  }) = _DevicePointerEvent;
}
