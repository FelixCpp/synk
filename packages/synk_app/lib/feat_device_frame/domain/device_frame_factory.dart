import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_frame/domain/device_frame_interactors.dart';

abstract interface class DeviceFrameFactory {
  DeviceFrameInteractors forConnection(DeviceConnection connection);
}
