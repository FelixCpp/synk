import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:use_in_case/use_in_case.dart';

class const DisconnectDeviceInteractor(
  final DeviceConnectionsRepository repository,
) implements ParameterizedInteractor<PluggedDevice> {
  @override
  Future<void> getOrThrow(PluggedDevice input) {
    return repository.disconnect(input);
  }
}
