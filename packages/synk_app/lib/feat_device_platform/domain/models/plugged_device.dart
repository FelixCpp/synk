import 'package:synk/feat_device_platform/domain/models/device_id.dart';

/// A device a platform has discovered. Each platform brings its own type.
abstract interface class PluggedDevice {
  DeviceId get id;
  String get modelName;

  /// Whether the device lets this host connect at all.
  bool get isAuthorized;
}
