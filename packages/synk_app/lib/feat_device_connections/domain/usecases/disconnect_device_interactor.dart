import 'package:synk/feat_device_connections/domain/device_connections_feature.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:use_in_case/use_in_case.dart';

class const DisconnectDeviceInteractor(
  final DeviceConnectionsFeature repository,
) implements ParameterizedInteractor<PluggedDevice> {
  @override
  Future<void> getOrThrow(PluggedDevice input) {
    return repository.disconnect(input);
  }
}
