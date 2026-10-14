part of 'screen_capture_preview_bloc.dart';

@freezed
sealed class ScreenCapturePreviewState with _$ScreenCapturePreviewState {
  const ScreenCapturePreviewState._();

  const factory ScreenCapturePreviewState({
    required List<ScreenCaptureEvent> captures,
  }) = _ScreenCapturePreviewState;

  factory ScreenCapturePreviewState.initial() {
    return const .new(captures: []);
  }

  ScreenCaptureEvent? get topmost => captures.firstOrNull;
}
