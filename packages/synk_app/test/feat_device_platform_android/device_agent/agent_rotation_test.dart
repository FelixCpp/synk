import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform_android/device_agent/agent_rotation.dart';
import 'package:synk/feat_device_platform_android/device_agent/android_device_agent_client.dart';

const _portrait = DeviceScreenSize(width: 1080, height: 2400);
const _landscape = DeviceScreenSize(width: 2400, height: 1080);

class _FakeAgent extends Fake implements AndroidDeviceAgentCommunicator {
  final lockedRotations = <int>[];
  var restores = 0;

  @override
  Future<void> lockRotation(int rotation) async {
    lockedRotations.add(rotation);
  }

  @override
  Future<void> restoreRotation() async {
    restores++;
  }
}

void main() {
  late _FakeAgent agent;
  late BehaviorSubject<DeviceScreenSize> screenSize;
  late AgentRotation rotation;

  setUp(() {
    agent = _FakeAgent();
    screenSize = BehaviorSubject.seeded(_portrait);
    rotation = AgentRotation(agent, screenSize: screenSize);
  });

  test('locks a portrait screen to landscape when turned left', () async {
    await rotation.rotate(.left);

    expect(agent.lockedRotations, [1]);
  });

  test('turns a portrait screen the other way when turned right', () async {
    await rotation.rotate(.right);

    expect(agent.lockedRotations, [3]);
  });

  test('locks a landscape screen back to portrait when turned right', () async {
    screenSize.add(_landscape);

    await rotation.rotate(.right);

    expect(agent.lockedRotations, [0]);
  });

  test('keeps turning from where the last turn left off', () async {
    await rotation.rotate(.left);
    await rotation.rotate(.left);
    await rotation.rotate(.left);
    await rotation.rotate(.left);
    await rotation.rotate(.right);

    expect(agent.lockedRotations, [1, 2, 3, 0, 3]);
  });

  test('hands the rotation back to the device once the session ends', () async {
    await rotation.rotate(.left);

    await rotation.restoreAutoRotation();

    expect(agent.restores, 1);
  });
}
