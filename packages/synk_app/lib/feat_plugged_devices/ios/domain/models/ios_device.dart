import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ios_device.freezed.dart';

@freezed
sealed class IosDevice with _$IosDevice implements PluggedDevice {
  const IosDevice._();

  const factory IosDevice({
    required DeviceId id,
    required String modelName,
  }) = _IosDevice;

  @override
  bool get isAuthorized => true;
}
