part of 'device_canvas_bloc.dart';

@freezed
sealed class DeviceCanvasEvent with _$DeviceCanvasEvent {
  const factory DeviceCanvasEvent.onSetup() = _OnSetup;
  const factory DeviceCanvasEvent.onCaptureScreenshot(CanvasDevice device) =
      _OnCaptureScreenshot;
  const factory DeviceCanvasEvent.onDeviceTapped({
    required CanvasDevice device,
    required ScrcpyTouchId action,
    required double normalizedX,
    required double normalizedY,
  }) = _OnDeviceTapped;
  const factory DeviceCanvasEvent.onCloseDevice(CanvasDevice device) =
      _OnCloseDevice;
  const factory DeviceCanvasEvent.onKeyEvent({
    required CanvasDevice device,
    required ScrcpyKeyAction action,
  }) = _OnKeyEvent;
}
