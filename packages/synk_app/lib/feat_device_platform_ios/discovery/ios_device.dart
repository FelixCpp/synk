import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';

part 'ios_device.freezed.dart';

@freezed
sealed class IosDevice with _$IosDevice implements PluggedDevice {
  const IosDevice._();

  const factory IosDevice({
    required DeviceId id,
    required String modelName,
  }) = _IosDevice;

  /// Trusting the host happens on the device, outside of synk; only trusted
  /// devices are discovered.
  @override
  bool get isAuthorized => true;
}
