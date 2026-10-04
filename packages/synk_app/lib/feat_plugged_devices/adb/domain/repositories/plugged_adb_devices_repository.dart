import 'package:synk/feat_plugged_devices/adb/domain/models/android_device.dart';

abstract interface class PluggedAdbDevicesRepository {
  Stream<List<AndroidDevice>> observeAdbDevices();
}
