import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';

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

enum AndroidDeviceState {
  any,
  connecting,
  authorizing,
  unauthorized,
  nopermission,
  detached,
  offline,
  bootloader,
  device,
  host,
  recovery,
  sideload,
  rescue,
}

enum AndroidDeviceConnection {
  usb,
  tcp,
  emulator,
  unknown,
}
