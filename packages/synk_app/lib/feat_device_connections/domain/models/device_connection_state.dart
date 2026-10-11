import 'package:synk/feat_device_connections/domain/models/connection_failure.dart';
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
