import 'package:api_adb/adb/devices/adb_connection_type_dto.dart';
import 'package:api_adb/adb/devices/adb_device_state_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'adb_device_dto.freezed.dart';

@freezed
sealed class AdbDeviceDto with _$AdbDeviceDto {
  const factory AdbDeviceDto({
    required String serialNumber,
    required AdbDeviceStateDto state,
    required AdbConnectionTypeDto connectionType,
    String? busAddress,
    String? product,
    String? model,
    String? device,
    int? negotiatedSpeed,
    int? maxSpeed,
    int? transportId,
  }) = _AdbDeviceDto;
}
