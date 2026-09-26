part of 'device_canvas_bloc.dart';

@freezed
sealed class DeviceCanvasState with _$DeviceCanvasState {
  const factory DeviceCanvasState({
    required List<CanvasDevice> devices,
  }) = _DeviceCanvasState;

  factory DeviceCanvasState.initial() {
    return const DeviceCanvasState(
      devices: [],
    );
  }
}
