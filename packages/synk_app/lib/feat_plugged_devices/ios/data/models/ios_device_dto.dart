import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:synk/feat_plugged_devices/ios/domain/models/ios_device.dart';

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
