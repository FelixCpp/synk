part of 'device_frame_bloc.dart';

@freezed
sealed class DeviceFrameEvent with _$DeviceFrameEvent {
  const factory DeviceFrameEvent.onSetup() = _OnSetup;
  const factory DeviceFrameEvent.onCaptureScreenshot() = _OnCaptureScreenshot;
  const factory DeviceFrameEvent.onToggleRecording() = _OnToggleRecording;
  const factory DeviceFrameEvent.onToggleAudioMute() = _OnToggleAudioMute;
  const factory DeviceFrameEvent.onPointerEvent(
    DevicePointerEventType type,
    double normalizedPointerX,
    double normalizedPointerY,
  ) = _OnPointerEvent;
  const factory DeviceFrameEvent.onPinchEvent(
    DevicePointerEventType type,
    double centerX,
    double centerY,
    double spread,
  ) = _OnPinchEvent;
  const factory DeviceFrameEvent.onKeyEvent(KeyEvent keyEvent) = _OnKeyEvent;
  const factory DeviceFrameEvent.onFilesDropped(List<String> filepaths) =
      _OnFilesDropped;

  const factory DeviceFrameEvent.onNavigate(DeviceNavigation navigation) =
      _OnNavigate;
  const factory DeviceFrameEvent.onPowerButtonPressed() = _OnPowerButtonPressed;
  const factory DeviceFrameEvent.onInstallApk() = _OnInstallApk;
  const factory DeviceFrameEvent.onShareFile() = _OnShareFile;
}
