import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_connection_state.freezed.dart';

@freezed
sealed class DeviceConnectionState with _$DeviceConnectionState {
  const factory DeviceConnectionState.disconnected() =
      ConnectionStateDisconnected;
  const factory DeviceConnectionState.connecting() = ConnectionStateConnecting;
  const factory DeviceConnectionState.connected() = ConnectionStateConnected;
  const factory DeviceConnectionState.failed({
    required ConnectionFailure failure,
  }) = ConnectionStateFailed;
}

enum ConnectionFailure {
  connectionRefused,
  cameraAccessDenied,
  unknown,
}
