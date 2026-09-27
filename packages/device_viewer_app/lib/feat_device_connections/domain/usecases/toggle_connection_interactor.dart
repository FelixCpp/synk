import 'package:device_viewer/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:use_in_case/use_in_case.dart';

class ToggleConnectionInteractor(
  final DeviceConnectionsRepository repository,
) implements ParameterizedInteractor<AndroidDevice> {
  @override
  Future<void> getOrThrow(AndroidDevice input) {
    return repository.toggleConnection(input);
  }
}
