import 'package:device_viewer/feat_maximized_device/domain/models/maximized_device.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';

abstract interface class MaximizedDeviceRepository {
  Stream<MaximizedDevice?> observeDevice(DeviceId deviceId);
}
