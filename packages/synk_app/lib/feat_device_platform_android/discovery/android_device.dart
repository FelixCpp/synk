import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device_connection.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device_state.dart';

part 'android_device.freezed.dart';

@freezed
sealed class AndroidDevice with _$AndroidDevice implements PluggedDevice {
  const AndroidDevice._();

  const factory AndroidDevice({
    required DeviceId id,
    required String modelName,
    required AndroidDeviceState state,
    required AndroidDeviceConnection connection,
  }) = _AndroidDevice;

  @override
  bool get isAuthorized => state == AndroidDeviceState.device;
}
