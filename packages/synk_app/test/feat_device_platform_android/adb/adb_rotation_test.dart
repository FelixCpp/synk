import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform_android/adb/adb_rotation.dart';

import '../../support/fake_adb_device_communicator.dart';
import '../../support/fake_process_manager.dart';

const _portrait = DeviceScreenSize(width: 1080, height: 2400);
const _landscape = DeviceScreenSize(width: 2400, height: 1080);

void main() {
  late FakeAdbDeviceCommunicator communicator;
  late BehaviorSubject<DeviceScreenSize> screenSize;
  late AdbRotation rotation;

  void connect({String autoRotation = '1'}) {
    communicator = FakeAdbDeviceCommunicator(
      process: FakeProcess(),
      shellOutput: (arguments) => arguments.contains('get') ? autoRotation : '',
    );
    rotation = AdbRotation(communicator, screenSize: screenSize);
  }

  List<List<String>> writes() => [
    for (final shell in communicator.shells)
      if (shell.contains('put')) shell,
  ];

  setUp(() {
    screenSize = BehaviorSubject.seeded(_portrait);
    connect();
  });

  test('locks a portrait screen to landscape', () async {
    await rotation.rotate();

    expect(writes(), [
      ['settings', 'put', 'system', 'accelerometer_rotation', '0'],
      ['settings', 'put', 'system', 'user_rotation', '1'],
    ]);
  });

  test('locks a landscape screen back to portrait', () async {
    screenSize.add(_landscape);

    await rotation.rotate();

    expect(writes().last, ['settings', 'put', 'system', 'user_rotation', '0']);
  });

  test('turns auto-rotation back on once the session ends', () async {
    await rotation.rotate();
    await rotation.rotate();
    communicator.shells.clear();

    await rotation.restoreAutoRotation();

    expect(writes(), [
      ['settings', 'put', 'system', 'accelerometer_rotation', '1'],
    ]);
  });

  test('leaves auto-rotation off if it was off before', () async {
    connect(autoRotation: '0');
    await rotation.rotate();
    communicator.shells.clear();

    await rotation.restoreAutoRotation();

    expect(writes(), [
      ['settings', 'put', 'system', 'accelerometer_rotation', '0'],
    ]);
  });

  test('touches no setting without a rotation', () async {
    await rotation.restoreAutoRotation();

    expect(communicator.shells, isEmpty);
  });
}
