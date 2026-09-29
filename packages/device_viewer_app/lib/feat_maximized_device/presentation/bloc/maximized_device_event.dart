part of 'maximized_device_bloc.dart';

@freezed
sealed class MaximizedDeviceEvent with _$MaximizedDeviceEvent {
  const factory MaximizedDeviceEvent.onSetup() = _OnSetup;
}
