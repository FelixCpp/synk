import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_device_dto.dart';

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

extension IosDeviceDtoToDomain on IosDeviceDto {
  IosDevice toDomain() {
    return IosDevice(
      id: DeviceId(serialNumber),
      modelName: productName ?? 'Unbekanntes Gerät',
    );
  }
}
