import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_key_action.dart';
import 'package:device_viewer/feat_device_agent/domain/models/scrcpy_touch_action.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';

abstract interface class DeviceCanvasRepository {
  Stream<List<CanvasDevice>> observeDevices();
  Future<void> captureScreenshot(AndroidDevice device);
  void simulateTouchEvent(AndroidDevice device, ScrcpyTouchAction action);
  void simulateKeyEvent(AndroidDevice device, ScrcpyKeyAction action);
}

class const DeviceNotConnectedException({
  required final DeviceId deviceId,
}) implements Exception {
  @override
  String toString() => 'Device $deviceId is not connected.';
}
