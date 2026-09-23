import 'package:freezed_annotation/freezed_annotation.dart';

part 'adb_device.freezed.dart';

@freezed
sealed class AdbDevice with _$AdbDevice {
  const factory AdbDevice({
    required String serialNumber,
    required String modelName,
    required String manufacturer,
  }) = _AdbDevice;
}
