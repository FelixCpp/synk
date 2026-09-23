import 'package:freezed_annotation/freezed_annotation.dart';

part 'adb_device_dto.freezed.dart';

@freezed
sealed class AdbDeviceDto with _$AdbDeviceDto {
  const factory AdbDeviceDto({
    required String serialNumber,
    required String modelName,
    required String manufacturer,
  }) = _AdbDeviceDto;
}
