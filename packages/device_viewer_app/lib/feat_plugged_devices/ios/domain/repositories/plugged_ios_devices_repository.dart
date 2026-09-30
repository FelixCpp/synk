import 'package:device_viewer/feat_plugged_devices/ios/domain/models/ios_device.dart';

abstract interface class PluggedIosDevicesRepository {
  Stream<List<IosDevice>> observeIosDevices();
}
