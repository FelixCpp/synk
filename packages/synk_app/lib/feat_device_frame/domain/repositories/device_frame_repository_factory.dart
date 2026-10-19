import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';

/// Builds the repository a single frame works through.
abstract interface class DeviceFrameRepositoryFactory {
  DeviceFrameRepository forConnection(DeviceConnection connection);
}
