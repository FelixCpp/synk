import 'dart:async';

import 'package:api_adb/adb/devices/adb_connection_type_dto.dart';
import 'package:api_adb/adb/devices/adb_device_state_dto.dart';
import 'package:api_adb/api_adb.dart';
import 'package:synk/feat_plugged_devices/adb/data/datasources/adb_devices_datasource.dart';
import 'package:synk/feat_plugged_devices/adb/data/repositories/plugged_adb_devices_repository_impl.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PluggedAdbDevicesRepositoryImpl', () {
    test(
      'hands a late listener the devices that are already plugged in',
      () async {
        final frames = StreamController<List<AdbDeviceDto>>();
        addTearDown(frames.close);

        final repository = PluggedAdbDevicesRepositoryImpl(
          _FakeAdbDevicesDatasource(frames.stream),
        );

        final seenByFirst = <List<AndroidDevice>>[];
        final first = repository.observeAdbDevices().listen(seenByFirst.add);
        addTearDown(first.cancel);

        frames.add(const [_pluggedDevice]);
        await pumpEventQueue();

        expect(seenByFirst, hasLength(1));

        // `adb track-devices` only speaks up when something is physically
        // plugged or unplugged. A listener that arrives later - the maximized
        // view subscribing when a device is blown up - would otherwise wait
        // forever for a frame that never comes.
        final seenByLate = await repository.observeAdbDevices().first.timeout(
          const Duration(seconds: 1),
        );

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

class _FakeAdbDevicesDatasource implements AdbDevicesDatasource {
  _FakeAdbDevicesDatasource(this._frames);

  final Stream<List<AdbDeviceDto>> _frames;

  @override
  Stream<List<AdbDeviceDto>> observeAdbDevices() => _frames;

  @override
  AdbApi get api => throw UnimplementedError();
}
