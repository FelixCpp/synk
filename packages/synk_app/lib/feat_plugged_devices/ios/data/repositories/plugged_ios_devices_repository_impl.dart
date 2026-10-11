import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:synk/feat_plugged_devices/ios/data/datasources/ios_device_discovery_channel.dart';
import 'package:synk/feat_plugged_devices/ios/domain/repositories/plugged_ios_devices_repository.dart';
import 'package:rxdart/rxdart.dart';

class PluggedIosDevicesRepositoryImpl(
  IosDeviceDiscoveryChannel channel,
) implements PluggedIosDevicesRepository {
  final Stream<List<IosDevice>> _devicesStream;

  this
    : _devicesStream = channel.observeDevices().map((dtos) {
        return dtos.map((dto) => dto.toDomain()).toList();
      }).shareValue();

  @override
  Stream<List<IosDevice>> observeIosDevices() {
    return _devicesStream;
  }
}
