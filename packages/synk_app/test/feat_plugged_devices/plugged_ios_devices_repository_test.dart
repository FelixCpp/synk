import 'dart:async';

import 'package:synk/feat_plugged_devices/ios/data/datasources/ios_device_discovery_channel.dart';
import 'package:synk/feat_plugged_devices/ios/data/models/ios_device_dto.dart';
import 'package:synk/feat_plugged_devices/ios/data/repositories/plugged_ios_devices_repository_impl.dart';
import 'package:synk/feat_plugged_devices/ios/domain/models/ios_device.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PluggedIosDevicesRepositoryImpl', () {
    test(
      'hands a late listener the devices that are already plugged in',
      () async {
        final frames = StreamController<List<IosDeviceDto>>();
        addTearDown(frames.close);

        final repository = PluggedIosDevicesRepositoryImpl(
          _FakeIosDeviceDiscoveryChannel(frames.stream),
        );

        final seenByFirst = <List<IosDevice>>[];
        final first = repository.observeIosDevices().listen(seenByFirst.add);
        addTearDown(first.cancel);

        frames.add(const [_pluggedDevice]);
        await pumpEventQueue();

        expect(seenByFirst, hasLength(1));

        final seenByLate = await repository.observeIosDevices().first.timeout(
          const Duration(seconds: 1),
        );

        expect(seenByLate.single.id, _pluggedDevice.serialNumber);
      },
    );
  });
}

const _pluggedDevice = IosDeviceDto(
  serialNumber: 'late-listener-ios-device',
  productName: 'iPhone',
);

class _FakeIosDeviceDiscoveryChannel implements IosDeviceDiscoveryChannel {
  _FakeIosDeviceDiscoveryChannel(this._frames);

  final Stream<List<IosDeviceDto>> _frames;

  @override
  Stream<List<IosDeviceDto>> observeDevices() => _frames;
}
