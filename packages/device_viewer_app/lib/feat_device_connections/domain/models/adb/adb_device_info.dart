import 'package:freezed_annotation/freezed_annotation.dart';

part 'adb_device_info.freezed.dart';

@freezed
sealed class AdbAgentDeviceInfo with _$AdbAgentDeviceInfo {
  const factory AdbAgentDeviceInfo({
    required String model,
    required String manufacturer,
    required String androidVersion,
    required int sdkVersion,
  }) = AdbAgentDeviceInfoInitial;
}
