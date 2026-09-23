import 'package:device_viewer/conversions/adb_device_dto.dart';
import 'package:device_viewer/feat_devices/adb/data/datasources/adb_process_datasource.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/adb_device.dart';
import 'package:device_viewer/feat_devices/adb/domain/repositories/adb_repository.dart';

class AdbDeviceRepositoryImpl implements AdbRepository {
  const new({required this.processDatasource});

  final AdbProcessDatasource processDatasource;

  @override
  Stream<List<AdbDevice>> observeAdbDevices() async* {
    await for (final _ in Stream.periodic(const .new(seconds: 5))) {
      final adbDeviceDtos = await processDatasource.fetchAdbDevices();
      final adbDevices = adbDeviceDtos.map((dto) => dto.toModel()).toList();

      yield adbDevices;
    }
  }
}
