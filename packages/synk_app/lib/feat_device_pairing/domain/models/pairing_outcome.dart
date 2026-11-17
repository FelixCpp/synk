import 'package:freezed_annotation/freezed_annotation.dart';

part 'pairing_outcome.freezed.dart';

@freezed
sealed class PairingOutcome with _$PairingOutcome {
  const factory PairingOutcome.connected() = PairingConnected;
  const factory PairingOutcome.connectPortResolved(int port) =
      PairingConnectPortResolved;
  const factory PairingOutcome.connectPortUnknown() = PairingConnectPortUnknown;
}
