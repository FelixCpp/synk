import 'dart:typed_data';

import 'package:api_adb/api_adb.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';

class const AdbDevicesDatasource({required final AdbApi api}) {
  Stream<List<AdbDeviceDto>> observeAdbDevices() {
    return api.observeDevices();
  }

  Future<Uint8List> captureScreenshot(AndroidDeviceId id) {
    return api.captureScreenshot(id);
  }
}
