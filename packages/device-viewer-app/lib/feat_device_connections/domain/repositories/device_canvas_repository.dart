import 'package:device_viewer/feat_device_connections/domain/models/adb_device_connection.dart';

abstract interface class DeviceConnectionsRepository {
  Stream<List<AdbDeviceConnection>> observeConnections();
}
