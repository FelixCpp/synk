import 'package:freezed_annotation/freezed_annotation.dart';

part 'adb_device_dto.freezed.dart';

enum AdbDeviceState {
  device,
  offline,
  unauthorized,
  recovery,
  sideload,
  authorizing,
  disconnect,
}

@freezed
sealed class AdbDeviceDto with _$AdbDeviceDto {
  const factory AdbDeviceDto({
    required String serialNumber,
    required AdbDeviceState state,
    required String? product,
    required String? model,
    required String? device,
    required String? transportId,
  }) = _AdbDeviceDto;
}
