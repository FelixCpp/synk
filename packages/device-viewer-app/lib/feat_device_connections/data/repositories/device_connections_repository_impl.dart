import 'package:device_viewer/feat_device_connections/domain/models/adb_device_connection.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_canvas_repository.dart';

class const DeviceConnectionsRepositoryImpl()
    implements DeviceConnectionsRepository {
  @override
  Stream<List<AdbDeviceConnection>> observeConnections() {
    return Stream.value(const []);
  }
}
