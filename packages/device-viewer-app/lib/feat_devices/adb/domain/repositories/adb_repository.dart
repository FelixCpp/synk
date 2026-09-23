import 'package:device_viewer/feat_devices/adb/domain/models/adb_device.dart';

abstract interface class AdbRepository {
  Stream<List<AdbDevice>> observeAdbDevices();
}
