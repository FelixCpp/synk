import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';

abstract interface class PluggedDevice {
  DeviceId get id;
  String get modelName;
  bool get isAuthorized;
}
