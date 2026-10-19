part of 'device_pairing_bloc.dart';

@freezed
sealed class DevicePairingEvent with _$DevicePairingEvent {
  const factory DevicePairingEvent.onSubmitted({
    required String hostPort,
    required String pairingCode,
  }) = _OnSubmitted;
}
