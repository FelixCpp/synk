part of 'device_canvas_bloc.dart';

@freezed
sealed class DeviceCanvasEvent with _$DeviceCanvasEvent {
  const factory DeviceCanvasEvent.onSetup() = _OnSetup;
  const factory DeviceCanvasEvent.onCaptureScreenshot(CanvasDevice device) =
      _OnCaptureScreenshot;
  const factory DeviceCanvasEvent.onToggleScreenMirror(CanvasDevice device) =
      _OnToggleScreenMirror;
}
