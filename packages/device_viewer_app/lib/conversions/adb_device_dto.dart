import 'package:api_adb/adb/devices/adb_device_dto.dart';
import 'package:device_viewer/conversions/android_connection_type.dart';
import 'package:device_viewer/conversions/android_device_state.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';

extension AdbDeviceDtoToModel on AdbDeviceDto {
  // TODO(Felix): Remote info field in adb_api
  AndroidDevice toDomain() {
    return AndroidDevice(
      id: DeviceId(serialNumber),
      modelName: model ?? "Unbekanntes Gerät",
      state: state.toDomain(),
      connection: connectionType.toDomain(serialNumber),
    );
  }
}
