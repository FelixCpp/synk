import 'package:synk/conversions/adb_device_dto.dart';
import 'package:synk/feat_plugged_devices/adb/data/datasources/adb_devices_datasource.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:synk/feat_plugged_devices/adb/domain/repositories/plugged_adb_devices_repository.dart';
import 'package:rxdart/rxdart.dart';

class PluggedAdbDevicesRepositoryImpl(
  AdbDevicesDatasource datasource,
) implements PluggedAdbDevicesRepository {
  final Stream<List<AndroidDevice>> _devicesStream;

  this
    : _devicesStream = datasource.observeAdbDevices().map((dtos) {
        return dtos.map((dto) => dto.toDomain()).toList();
      }).shareValue();

  @override
  Stream<List<AndroidDevice>> observeAdbDevices() {
    return _devicesStream;
  }
}
