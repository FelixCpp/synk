part of 'device_frame_bloc.dart';

@freezed
sealed class DeviceFrameEvent with _$DeviceFrameEvent {
  const factory DeviceFrameEvent.onSetup() = _OnSetup;
  const factory DeviceFrameEvent.onCaptureScreenshot() = _OnCaptureScreenshot;
  const factory DeviceFrameEvent.onPointerEvent(
    ScrcpyPointerEventType type,
    double normalizedPointerX,
    double normalizedPointerY,
  ) = _OnPointerEvent;
  const factory DeviceFrameEvent.onKeyEvent(KeyEvent keyEvent) = _OnKeyEvent;
  const factory DeviceFrameEvent.onFilesDropped(List<String> filepaths) =
      _OnFilesDropped;

  const factory DeviceFrameEvent.onControlButtonPressed(
    ControlButtonType type,
  ) = _OnControlButtonPressed;
  const factory DeviceFrameEvent.onInstallApk() = _OnInstallApk;
  const factory DeviceFrameEvent.onShareFile() = _OnShareFile;
}
