import 'dart:typed_data';

import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/android_device.dart';

abstract interface class DeviceCanvasRepository {
  Stream<List<CanvasDevice>> observeDevices();
  Future<void> captureScreenshot(AndroidDevice device);

  Future<Stream<Uint8List>> startScreenMirror(AndroidDevice device);
  Future<void> stopScreenMirror(AndroidDevice device);
}

class const DeviceNotConnectedException({
  required final AndroidDeviceId deviceId,
}) implements Exception {
  @override
  String toString() => 'Device $deviceId is not connected.';
}
