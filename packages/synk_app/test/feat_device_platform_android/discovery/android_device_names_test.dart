import 'package:api_adb/adb/devices/adb_connection_type_dto.dart';
import 'package:api_adb/adb/devices/adb_device_state_dto.dart';
import 'package:api_adb/api_adb.dart';
import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device_names.dart';

import '../../support/fake_adb_device_communicator.dart';
import '../../support/fake_process_manager.dart';

const _emulator = AdbDeviceDto(
  serialNumber: 'emulator-5554',
  state: AdbDeviceStateDto.device,
  connectionType: AdbConnectionTypeDto.socket,
  model: 'sdk_gphone64_arm64',
);

const _phone = AdbDeviceDto(
  serialNumber: '18131FDF6002UE',
  state: AdbDeviceStateDto.device,
  connectionType: AdbConnectionTypeDto.usb,
  model: 'Pixel_6',
);

void main() {
  late MemoryFileSystem fileSystem;
  late _FakeAdbApi api;
  late AndroidDeviceNames names;

  setUp(() {
    fileSystem = MemoryFileSystem();
    api = _FakeAdbApi();
    names = AndroidDeviceNames(
      api,
      fileSystem: fileSystem,
      environment: const {'HOME': '/Users/dev'},
    );
  });

  void writeAvd(String id, {String? displayName}) {
    fileSystem.file('/Users/dev/.android/avd/$id.ini')
      ..createSync(recursive: true)
      ..writeAsStringSync('path=/Users/dev/.android/avd/$id.avd\n');
    fileSystem.file('/Users/dev/.android/avd/$id.avd/config.ini')
      ..createSync(recursive: true)
      ..writeAsStringSync(
        'hw.lcd.width=1080\n'
        '${displayName == null ? '' : 'avd.ini.displayname=$displayName\n'}',
      );
  }

  test('names an emulator like the device manager does', () async {
    api.properties['emulator-5554'] = {
      'ro.boot.qemu.avd_name': 'Pixel_8_API_35',
    };
    writeAvd('Pixel_8_API_35', displayName: 'Mein Pixel 8');

    final resolved = await names.namesOf(const [_emulator]);

    expect(resolved, {'emulator-5554': 'Mein Pixel 8'});
  });

  test('derives the name from the AVD id without a display name', () async {
    api.properties['emulator-5554'] = {
      'ro.kernel.qemu.avd_name': 'Pixel_8_API_35',
    };

    final resolved = await names.namesOf(const [_emulator]);

    expect(resolved, {'emulator-5554': 'Pixel 8 API 35'});
  });

  test('follows the path of an AVD stored elsewhere', () async {
    api.properties['emulator-5554'] = {'ro.boot.qemu.avd_name': 'Tablet'};
    fileSystem.file('/Users/dev/.android/avd/Tablet.ini')
      ..createSync(recursive: true)
      ..writeAsStringSync('path=/Volumes/External/Tablet.avd\n');
    fileSystem.file('/Volumes/External/Tablet.avd/config.ini')
      ..createSync(recursive: true)
      ..writeAsStringSync('avd.ini.displayname=Großes Tablet\n');

    final resolved = await names.namesOf(const [_emulator]);

    expect(resolved, {'emulator-5554': 'Großes Tablet'});
  });

  test('prefers ANDROID_AVD_HOME over the home directory', () async {
    names = AndroidDeviceNames(
      api,
      fileSystem: fileSystem,
      environment: const {'HOME': '/Users/dev', 'ANDROID_AVD_HOME': '/avds'},
    );
    api.properties['emulator-5554'] = {'ro.boot.qemu.avd_name': 'Pixel'};
    fileSystem.file('/avds/Pixel.avd/config.ini')
      ..createSync(recursive: true)
      ..writeAsStringSync('avd.ini.displayname=Pixel aus AVD_HOME\n');

    final resolved = await names.namesOf(const [_emulator]);

    expect(resolved, {'emulator-5554': 'Pixel aus AVD_HOME'});
  });

  test('names a phone after its manufacturer and model', () async {
    api.properties['18131FDF6002UE'] = {
      'ro.product.manufacturer': 'samsung',
      'ro.product.model': 'SM-G991B',
    };

    final resolved = await names.namesOf(const [_phone]);

    expect(resolved, {'18131FDF6002UE': 'Samsung SM-G991B'});
  });

  test('does not repeat a manufacturer the model already names', () async {
    api.properties['18131FDF6002UE'] = {
      'ro.product.manufacturer': 'OnePlus',
      'ro.product.model': 'OnePlus 9',
    };

    final resolved = await names.namesOf(const [_phone]);

    expect(resolved, {'18131FDF6002UE': 'OnePlus 9'});
  });

  test('falls back to the adb model of an unauthorized device', () async {
    final resolved = await names.namesOf([
      _phone.copyWith(state: AdbDeviceStateDto.unauthorized),
    ]);

    expect(resolved, {'18131FDF6002UE': 'Pixel 6'});
    expect(api.connected, isEmpty);
  });

  test('asks every authorized device only once', () async {
    api.properties['18131FDF6002UE'] = {'ro.product.model': 'Pixel 6'};

    await names.namesOf(const [_phone]);
    await names.namesOf(const [_phone]);

    expect(api.connected, ['18131FDF6002UE']);
  });

  test('asks again once an emulator serial is reused', () async {
    api.properties['emulator-5554'] = {'ro.boot.qemu.avd_name': 'First'};
    await names.namesOf(const [_emulator]);
    await names.namesOf(const []);

    api.properties['emulator-5554'] = {'ro.boot.qemu.avd_name': 'Second'};
    final resolved = await names.namesOf(const [_emulator]);

    expect(resolved, {'emulator-5554': 'Second'});
  });
}

class _FakeAdbApi implements AdbApi {
  final properties = <String, Map<String, String>>{};
  final connected = <String>[];

  @override
  AdbDeviceCommunicator connect(String serialNumber) {
    connected.add(serialNumber);

    return FakeAdbDeviceCommunicator(
      process: FakeProcess(),
      shellOutput: (_) => [
        for (final MapEntry(:key, :value)
            in (properties[serialNumber] ?? const {}).entries)
          '[$key]: [$value]',
      ].join('\n'),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
