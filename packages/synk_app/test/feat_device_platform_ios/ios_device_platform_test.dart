import 'dart:async';

import 'package:api_devicectl/api_devicectl.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_device_discovery_channel.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_device_dto.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_hid_channel.dart';
import 'package:synk/feat_device_platform_ios/ios_device_platform.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_media_stream_channel.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_channel.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_device.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IosDevicePlatform.observeDevices', () {
    test(
      'hands a late listener the devices that are already plugged in',
      () async {
        final frames = StreamController<List<IosDeviceDto>>();
        addTearDown(frames.close);

        final platform = IosDevicePlatform(
          discoveryChannel: _FakeIosDeviceDiscoveryChannel(frames.stream),
          channel: IosMirrorChannel(),
          mediaStreamChannel: IosMediaStreamChannel(),
          hidChannel: IosHidChannel(),
          devicectl: DevicectlApi(),
        );

        final seenByFirst = <List<PluggedDevice>>[];
        final first = platform.observeDevices().listen(seenByFirst.add);
        addTearDown(first.cancel);

        frames.add(const [_pluggedDevice]);
        await pumpEventQueue();

        expect(seenByFirst, hasLength(1));

        final seenByLate = await platform.observeDevices().first.timeout(
          const Duration(seconds: 1),
        );

        expect(seenByLate.single, isA<IosDevice>());
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
