part of 'device_canvas_bloc.dart';

@freezed
sealed class DeviceCanvasEvent with _$DeviceCanvasEvent {
  const factory DeviceCanvasEvent.onSetup() = _OnSetup;
  const factory DeviceCanvasEvent.onCaptureScreenshot(CanvasDevice device) =
      _OnCaptureScreenshot;
  const factory DeviceCanvasEvent.onPointerEvent({
    required CanvasDevice device,
    required ScrcpyPointerEventType type,
    required double normalizedPointerX,
    required double normalizedPointerY,
  }) = _OnPointerEvent;
  const factory DeviceCanvasEvent.onCloseDevice(CanvasDevice device) =
      _OnCloseDevice;
  const factory DeviceCanvasEvent.onKeyEvent({
    required CanvasDevice device,
    required KeyEvent event,
  }) = _OnKeyEvent;
}
