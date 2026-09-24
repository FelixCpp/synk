import 'package:freezed_annotation/freezed_annotation.dart';

part 'android_device_info.freezed.dart';

@freezed
sealed class AndroidDeviceInfo with _$AndroidDeviceInfo {
  const factory AndroidDeviceInfo({
    required String? product,
    required String? model,
    required String? codename,
  }) = _AndroidDeviceInfo;
}
