import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';

abstract interface class PluggedAdbDevicesRepository {
  Stream<List<AndroidDevice>> observeAdbDevices();
}
