part of 'maximized_device_bloc.dart';

@freezed
sealed class MaximizedDeviceState with _$MaximizedDeviceState {
  const factory MaximizedDeviceState({
    required MaximizedDevice device,
    required bool isGone,
  }) = _MaximizedDeviceState;
}
