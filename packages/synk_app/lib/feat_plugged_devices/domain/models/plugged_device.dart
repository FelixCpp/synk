import 'package:synk/feat_plugged_devices/adb/domain/models/android_device_connection.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device_state.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'plugged_device.freezed.dart';

@freezed
sealed class PluggedDevice with _$PluggedDevice {
  const PluggedDevice._();

  const factory PluggedDevice.android({
    required DeviceId id,
    required String modelName,
    required AndroidDeviceState state,
    required AndroidDeviceConnection connection,
  }) = AndroidDevice;

  const factory PluggedDevice.ios({
    required DeviceId id,
    required String modelName,
  }) = IosDevice;

  bool get isAuthorized => switch (this) {
    AndroidDevice(:final state) => state == AndroidDeviceState.device,
    IosDevice() => true,
  };

  bool get supportsDeviceActions => switch (this) {
    AndroidDevice() => true,
    IosDevice() => false,
  };
}
