part of 'device_canvas_bloc.dart';

@freezed
sealed class DeviceCanvasEvent with _$DeviceCanvasEvent {
  const factory DeviceCanvasEvent.onSetup() = _OnSetup;
  const factory DeviceCanvasEvent.onCloseDevice(CanvasDevice device) =
      _OnCloseDevice;
}
