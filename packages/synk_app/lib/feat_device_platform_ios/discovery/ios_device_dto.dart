import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_device.dart';

class IosDeviceDto {
  const IosDeviceDto({
    required this.serialNumber,
    required this.productName,
  });

  factory IosDeviceDto.fromMap(Map<Object?, Object?> map) {
    return IosDeviceDto(
      serialNumber: map['id'] as String,
      productName: map['productName'] as String?,
    );
  }

  final String serialNumber;
  final String? productName;

  IosDevice toDomain() {
    return IosDevice(
      id: DeviceId(serialNumber),
      modelName: productName ?? 'Unbekanntes Gerät',
    );
  }
}
