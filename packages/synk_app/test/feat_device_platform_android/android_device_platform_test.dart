import 'dart:async';

import 'package:api_adb/adb/devices/adb_connection_type_dto.dart';
import 'package:api_adb/adb/devices/adb_device_state_dto.dart';
import 'package:api_adb/api_adb.dart';
import 'package:clock/clock.dart';
import 'package:file/memory.dart';
import 'package:synk/feat_device_platform_android/bundled_files.dart';
import 'package:synk/feat_device_platform_android/android_device_platform.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_asset_bundle.dart';

void main() {
  group('AndroidDevicePlatform.observeDevices', () {
    test(
      'hands a late listener the devices that are already plugged in',
      () async {
        final frames = StreamController<List<AdbDeviceDto>>();
        addTearDown(frames.close);

        final platform = AndroidDevicePlatform(
          _FakeAdbApi(frames.stream),
          bundledFiles: BundledFiles(
            bundle: FakeAssetBundle(const {}),
            fileSystem: MemoryFileSystem(),
            directory: '/cache',
          ),
          clock: const Clock(),
        );

        final seenByFirst = <List<PluggedDevice>>[];
        final first = platform.observeDevices().listen(seenByFirst.add);
        addTearDown(first.cancel);

        frames.add(const [_pluggedDevice]);
        await pumpEventQueue();

        expect(seenByFirst, hasLength(1));

        // `adb track-devices` only speaks up when something is physically
        // plugged or unplugged. A listener that arrives later - the maximized
        // view subscribing when a device is blown up - would otherwise wait
        // forever for a frame that never comes.
        final seenByLate = await platform.observeDevices().first.timeout(
          const Duration(seconds: 1),
        );

        expect(seenByLate.single, isA<AndroidDevice>());
        expect(seenByLate.single.id, _pluggedDevice.serialNumber);
      },
    );
  });
}

const _pluggedDevice = AdbDeviceDto(
  serialNumber: 'late-listener-device',
  state: AdbDeviceStateDto.device,
  connectionType: AdbConnectionTypeDto.usb,
  model: 'Test Device',
);

class _FakeAdbApi implements AdbApi {
  _FakeAdbApi(this._frames);

  final Stream<List<AdbDeviceDto>> _frames;

  @override
  Stream<List<AdbDeviceDto>> observeDevices() => _frames;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
