part of 'device_pairing_bloc.dart';

@freezed
sealed class DevicePairingState with _$DevicePairingState {
  const factory DevicePairingState.editing({String? error}) =
      DevicePairingEditing;
  const factory DevicePairingState.pairing() = DevicePairingPairing;
  const factory DevicePairingState.connectPortNeeded({
    required String host,
    String? error,
  }) = DevicePairingConnectPortNeeded;
  const factory DevicePairingState.connecting({required String host}) =
      DevicePairingConnecting;
  const factory DevicePairingState.connected() = DevicePairingConnected;
}
