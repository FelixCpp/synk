import 'package:device_viewer/feat_devices/adb/domain/models/adb_device.dart';

abstract interface class AdbDevicesRepository {
  Stream<List<AdbDevice>> observeAdbDevices();
}
