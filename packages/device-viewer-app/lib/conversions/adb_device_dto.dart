import 'package:api_adb/adb/dtos/adb_device_dto.dart';
import 'package:device_viewer/conversions/android_connection_type.dart';
import 'package:device_viewer/conversions/android_device_state.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device_info.dart';

extension AdbDeviceDtoToModel on AdbDeviceDto {
  AndroidDevice toDomain() {
    return AndroidDevice(
      id: AndroidDeviceId(serialNumber),
      state: state.toDomain(),
      connection: connectionType.toDomain(serialNumber),
      info: AndroidDeviceInfo(
        product: product,
        model: model,
        codename: device,
      ),
    );
  }
}
