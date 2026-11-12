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

  List<String> userRotations() => [
    for (final write in writes())
      if (write.contains('user_rotation')) write.last,
  ];

  test('locks a portrait screen to landscape when turned left', () async {
    await rotation.rotate(.left);

    expect(writes(), [
      ['settings', 'put', 'system', 'accelerometer_rotation', '0'],
      ['settings', 'put', 'system', 'user_rotation', '1'],
    ]);
  });

  test('turns a portrait screen the other way when turned right', () async {
    await rotation.rotate(.right);

    expect(userRotations(), ['3']);
  });

  test('locks a landscape screen back to portrait when turned right', () async {
    screenSize.add(_landscape);

    await rotation.rotate(.right);

    expect(userRotations(), ['0']);
  });

  test('keeps turning from where the last turn left off', () async {
    await rotation.rotate(.left);
    await rotation.rotate(.left);
    await rotation.rotate(.left);
    await rotation.rotate(.left);
    await rotation.rotate(.right);

    expect(userRotations(), ['1', '2', '3', '0', '3']);
  });

  test('turns auto-rotation back on once the session ends', () async {
    await rotation.rotate(.left);
    await rotation.rotate(.left);
    communicator.shells.clear();

    await rotation.restoreAutoRotation();

    expect(writes(), [
      ['settings', 'put', 'system', 'accelerometer_rotation', '1'],
    ]);
  });

  test('leaves auto-rotation off if it was off before', () async {
    connect(autoRotation: '0');
    await rotation.rotate(.left);
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
