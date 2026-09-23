import 'package:device_viewer/feat_devices/adb/domain/models/adb_device_identity.dart';

abstract interface class AdbRepository {
  Stream<List<AdbDeviceIdentity>> observeAdbDevices();
}
