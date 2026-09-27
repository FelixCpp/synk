import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_touch_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scrcpy_touch_action.freezed.dart';

@freezed
sealed class ScrcpyTouchAction with _$ScrcpyTouchAction {
  const factory ScrcpyTouchAction({
    required ScrcpyTouchId id,
    required double normalizedTouchX,
    required double normalizedTouchY,
  }) = _ScrcpyTouchAction;
}
