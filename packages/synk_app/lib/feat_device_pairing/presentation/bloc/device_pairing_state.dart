part of 'device_pairing_bloc.dart';

@freezed
sealed class DevicePairingState with _$DevicePairingState {
  const factory DevicePairingState.editing({String? error}) =
      DevicePairingEditing;
  const factory DevicePairingState.pairing() = DevicePairingPairing;
  const factory DevicePairingState.paired() = DevicePairingPaired;
}
