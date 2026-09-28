import 'package:freezed_annotation/freezed_annotation.dart';

part 'scrcpy_key_action.freezed.dart';

@freezed
sealed class ScrcpyKeyAction with _$ScrcpyKeyAction {
  const factory ScrcpyKeyAction.down({
    required int keyCode,
    required int metaState,
  }) = _ScrcpyKeyDownAction;

  const factory ScrcpyKeyAction.repeat({
    required int keyCode,
    required int repeat,
    required int metaState,
  }) = _ScrcpyKeyRepeatAction;

  const factory ScrcpyKeyAction.up({
    required int keyCode,
    required int metaState,
  }) = _ScrcpyKeyUpAction;
}
