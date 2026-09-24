import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';

abstract interface class AdbDevicesRepository {
  Stream<List<AndroidDevice>> observeAdbDevices();
}
