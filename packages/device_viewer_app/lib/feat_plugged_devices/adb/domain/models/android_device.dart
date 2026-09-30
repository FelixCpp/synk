import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device_connection.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device_state.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
