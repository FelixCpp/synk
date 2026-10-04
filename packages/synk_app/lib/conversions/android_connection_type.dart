import 'package:api_adb/adb/devices/adb_connection_type_dto.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device_connection.dart';

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
