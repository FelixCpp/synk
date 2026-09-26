import 'package:api_adb/api_adb.dart';

class const AdbDevicesDatasource({required final AdbApi api}) {
  Stream<List<AdbDeviceDto>> observeAdbDevices() {
    return api.observeDevices();
  }
}
