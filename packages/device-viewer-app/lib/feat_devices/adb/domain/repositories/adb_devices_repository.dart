import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';
import 'package:flutter/services.dart';

abstract interface class AdbDevicesRepository {
  Stream<List<AndroidDevice>> observeAdbDevices();
  Future<Uint8List> captureScreenshot(AndroidDeviceId id);
}
