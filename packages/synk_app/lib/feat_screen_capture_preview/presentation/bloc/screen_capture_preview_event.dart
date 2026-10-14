part of 'screen_capture_preview_bloc.dart';

@freezed
sealed class ScreenCapturePreviewEvent with _$ScreenCapturePreviewEvent {
  const factory ScreenCapturePreviewEvent.onSetup() = _OnSetup;

  const factory ScreenCapturePreviewEvent.onPreviewPressed(
    ScreenCaptureEvent capture,
  ) = _OnPreviewPressed;

  const factory ScreenCapturePreviewEvent.onPreviewDismissed(
    ScreenCaptureEvent capture,
  ) = _OnPreviewDismissed;
}
