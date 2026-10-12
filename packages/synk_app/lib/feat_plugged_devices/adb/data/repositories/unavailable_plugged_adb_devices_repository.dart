import 'package:synk/feat_plugged_devices/adb/domain/repositories/plugged_adb_devices_repository.dart';
import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';

/// Stands in for the adb-backed repository when adb is unusable: no process is
/// started and no Android device ever shows up.
class const UnavailablePluggedAdbDevicesRepository()
    implements PluggedAdbDevicesRepository {
  @override
  Stream<List<AndroidDevice>> observeAdbDevices() {
    return Stream.value(const []);
  }
}
