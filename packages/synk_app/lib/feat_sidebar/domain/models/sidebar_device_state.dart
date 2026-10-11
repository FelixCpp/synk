import 'package:synk/feat_device_connections/domain/models/connection_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sidebar_device_state.freezed.dart';

@freezed
sealed class SidebarDeviceState with _$SidebarDeviceState {
  const factory SidebarDeviceState.disconnected() = SidebarDeviceDisconnected;
  const factory SidebarDeviceState.connecting() = SidebarDeviceConnecting;
  const factory SidebarDeviceState.connected() = SidebarDeviceConnected;
  const factory SidebarDeviceState.failedToConnect({
    required ConnectionFailure failure,
  }) = SidebarDeviceFailedToConnect;
  const factory SidebarDeviceState.unableToConnect() =
      SidebarDeviceUnableToConnect;
}
