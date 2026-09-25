import 'package:device_viewer/conversions/adb_device_dto.dart';
import 'package:device_viewer/feat_devices/adb/data/datasources/adb_devices_datasource.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_devices/adb/domain/repositories/adb_devices_repository.dart';

class AdbDevicesRepositoryImpl(
  final AdbDevicesDatasource datasource,
) implements AdbDevicesRepository {
  Stream<List<AndroidDevice>>? _devicesStream;

  @override
  Stream<List<AndroidDevice>> observeAdbDevices() {
    _devicesStream ??= datasource
        .observeAdbDevices()
        .map((dtos) {
          return dtos.map((dto) => dto.toDomain()).toList();
        })
        .asBroadcastStream(
          onListen: (subscription) => subscription.resume(),
          onCancel: (subscription) => subscription.pause(),
        );

    return _devicesStream!;
  }
}
