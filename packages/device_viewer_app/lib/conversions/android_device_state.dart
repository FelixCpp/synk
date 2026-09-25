import 'package:api_adb/adb/dtos/adb_device_state_dto.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device_state.dart';

extension AdbDeviceStateDtoToDomain on AdbDeviceStateDto {
  AndroidDeviceState toDomain() {
    return switch (this) {
      .any => .any,
      .connecting => .connecting,
      .authorizing => .authorizing,
      .unauthorized => .unauthorized,
      .nopermission => .nopermission,
      .detached => .detached,
      .offline => .offline,
      .bootloader => .bootloader,
      .device => .device,
      .host => .host,
      .recovery => .recovery,
      .sideload => .sideload,
      .rescue => .rescue,
    };
  }
}
