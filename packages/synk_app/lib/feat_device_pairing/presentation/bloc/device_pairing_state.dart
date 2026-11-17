part of 'device_pairing_bloc.dart';

@freezed
sealed class DevicePairingState with _$DevicePairingState {
  const factory DevicePairingState({
    @Default(DevicePairingStep.editing()) DevicePairingStep step,
    @Default(<PairableDevice>[]) List<PairableDevice> pairableDevices,
  }) = _DevicePairingState;
}

@freezed
sealed class DevicePairingStep with _$DevicePairingStep {
  const factory DevicePairingStep.editing({String? error}) =
      DevicePairingEditing;
  const factory DevicePairingStep.pairing() = DevicePairingPairing;
  const factory DevicePairingStep.connectPortNeeded({
    required String host,
    String? error,
  }) = DevicePairingConnectPortNeeded;
  const factory DevicePairingStep.connecting({required String host}) =
      DevicePairingConnecting;
  const factory DevicePairingStep.connected() = DevicePairingConnected;
}
