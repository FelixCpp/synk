import 'package:api_adb/adb/devices/adb_device_state_dto.dart';
import 'package:api_adb/adb/proto/generated/lib/adb/proto/devices.pbenum.dart';

extension ConnectionStateToDto on ConnectionState {
  AdbDeviceStateDto toDto() {
    return switch (this) {
      ConnectionState.ANY => .any,
      ConnectionState.CONNECTING => .connecting,
      ConnectionState.AUTHORIZING => .authorizing,
      ConnectionState.UNAUTHORIZED => .unauthorized,
      ConnectionState.NOPERMISSION => .nopermission,
      ConnectionState.DETACHED => .detached,
      ConnectionState.OFFLINE => .offline,
      ConnectionState.BOOTLOADER => .bootloader,
      ConnectionState.DEVICE => .device,
      ConnectionState.HOST => .host,
      ConnectionState.RECOVERY => .recovery,
      ConnectionState.SIDELOAD => .sideload,
      ConnectionState.RESCUE => .rescue,
      _ => throw Exception('Invalid State'),
    };
  }
}
