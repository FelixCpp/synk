import 'package:device_viewer/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:use_in_case/use_in_case.dart';

class ToggleConnectionInteractor(
  final DeviceConnectionsRepository repository,
) implements ParameterizedInteractor<PluggedDevice> {
  @override
  Future<void> getOrThrow(PluggedDevice input) {
    return repository.toggleConnection(input);
  }
}
