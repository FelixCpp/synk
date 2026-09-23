import 'package:api_adb/adb/dtos/adb_device_dto.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/adb_device.dart';

extension AdbDeviceDtoToModel on AdbDeviceDto {
  AdbDevice toModel() {
    return AdbDevice(
      serialNumber: serialNumber,
      modelName: modelName,
      manufacturer: manufacturer,
    );
  }
}
