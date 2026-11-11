import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sidebar_device_state.freezed.dart';

@freezed
sealed class SidebarDeviceState with _$SidebarDeviceState {
  const factory SidebarDeviceState.disconnected() = _Disconnected;
  const factory SidebarDeviceState.connecting() = _Connecting;
  const factory SidebarDeviceState.connected() = _Connected;
  const factory SidebarDeviceState.failedToConnect({
    required ConnectionFailure failure,
  }) = _FailedToConnect;
  const factory SidebarDeviceState.unableToConnect() = _UnableToConnect;
}
