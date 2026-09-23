import 'package:api_adb/api_adb.dart';

class AdbProcessDatasource {
  const new({required this.api});

  final AdbApi api;

  Future<List<AdbDeviceDto>> fetchAdbDevices() {
    return api.fetchDevices();
  }
}
