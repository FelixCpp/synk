import 'package:api_adb/adb/devices/adb_connection_type_dto.dart';
import 'package:api_adb/adb/devices/adb_device_dto.dart';
import 'package:api_adb/adb/devices/adb_device_state_dto.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device.dart';

extension AdbDeviceDtoToModel on AdbDeviceDto {
  AndroidDevice toDomain() {
    return AndroidDevice(
      id: DeviceId(serialNumber),
      modelName: model ?? "Unbekanntes Gerät",
      state: state.toDomain(),
      connection: connectionType.toDomain(serialNumber),
    );
  }
}

extension AdbConnectionTypeToDomain on AdbConnectionTypeDto {
  AndroidDeviceConnection toDomain(String serialNumber) {
    if (serialNumber.startsWith('emulator-')) {
      return .emulator;
    }

    return switch (this) {
      AdbConnectionTypeDto.unknown => .unknown,
      AdbConnectionTypeDto.usb => .usb,
      AdbConnectionTypeDto.socket => .tcp,
    };
  }
}

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
