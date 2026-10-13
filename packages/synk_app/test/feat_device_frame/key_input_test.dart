import 'package:synk/feat_device_platform/application/device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/interaction_device_agent.dart';
import 'package:synk/feat_device_platform/domain/models/device_navigation.dart';
import 'package:synk/feat_device_platform/domain/models/pinch_event.dart';
import 'package:synk/feat_device_platform/domain/models/device_key_event.dart';
import 'package:synk/feat_device_platform/domain/models/device_pointer_event.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_device_agent.dart';

const _deviceId = DeviceId('serial-1');

DeviceKeyEvent _key(
  LogicalKeyboardKey key, {
  DeviceKeyEventType type = DeviceKeyEventType.down,
  Set<DeviceKeyModifier> modifiers = const {},
}) {
  return DeviceKeyEvent(key: key, type: type, modifiers: modifiers);
}

void main() {
  late _RecordingInteractionAgent agent;
  late DeviceFrameRepository repository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    agent = _RecordingInteractionAgent();
    repository = DeviceFrameRepository(
      repository: _ConnectionsWithInteraction(agent),
    );
  });

  group('typing on the host', () {
    test('reaches the device for an ordinary letter', () async {
      await repository.simulateKeyEvent(
        _deviceId,
        _key(LogicalKeyboardKey.keyA),
      );

      expect(agent.keyEvents.single.key, LogicalKeyboardKey.keyA);
      expect(agent.keyEvents.single.type, DeviceKeyEventType.down);
    });

    test('reaches the device for every phase of a keystroke', () async {
      for (final type in DeviceKeyEventType.values) {
        await repository.simulateKeyEvent(
          _deviceId,
          _key(LogicalKeyboardKey.keyA, type: type),
        );
      }

      expect(
        agent.keyEvents.map((event) => event.type),
        DeviceKeyEventType.values,
      );
    });

    test('reaches the device for a letter held with a modifier', () async {
      await repository.simulateKeyEvent(
        _deviceId,
        _key(
          LogicalKeyboardKey.keyA,
          modifiers: const {DeviceKeyModifier.shiftLeft},
        ),
      );

      expect(agent.keyEvents.single.key, LogicalKeyboardKey.keyA);
    });

    test('carries the modifiers along for the agent to translate', () async {
      await repository.simulateKeyEvent(
        _deviceId,
        _key(
          LogicalKeyboardKey.keyA,
          modifiers: const {
            DeviceKeyModifier.shiftLeft,
            DeviceKeyModifier.capsLock,
          },
        ),
      );

      expect(agent.keyEvents.single.modifiers, {
        DeviceKeyModifier.shiftLeft,
        DeviceKeyModifier.capsLock,
      });
    });

    test('stops at the host for the clipboard shortcuts', () async {
      for (final key in [LogicalKeyboardKey.keyC, LogicalKeyboardKey.keyV]) {
        for (final type in DeviceKeyEventType.values) {
          await repository.simulateKeyEvent(
            _deviceId,
            _key(
              key,
              type: type,
              modifiers: const {DeviceKeyModifier.metaLeft},
            ),
          );
        }
      }

      expect(agent.keyEvents, isEmpty);
    });

    test('reaches the device for c and v without the meta key', () async {
      await repository.simulateKeyEvent(
        _deviceId,
        _key(LogicalKeyboardKey.keyC),
      );
      await repository.simulateKeyEvent(
        _deviceId,
        _key(LogicalKeyboardKey.keyV),
      );

      expect(
        agent.keyEvents.map((event) => event.key),
        [LogicalKeyboardKey.keyC, LogicalKeyboardKey.keyV],
      );
    });
  });
}

class _RecordingInteractionAgent implements InteractionDeviceAgent {
  final keyEvents = <DeviceKeyEvent>[];

  @override
  Future<void> simulateKeyEvent(DeviceKeyEvent event) async {
    keyEvents.add(event);
  }

  @override
  Future<void> simulatePointerEvent(DevicePointerEvent event) async {}

  @override
  Future<void> simulatePinchEvent(PinchEvent event) async {}

  @override
  Set<DeviceNavigation> get supportedNavigations => const {};

  @override
  Future<void> navigate(DeviceNavigation navigation) async {}

  @override
  Future<void> pressPowerButton() async {}
}

class _ConnectionsWithInteraction(final InteractionDeviceAgent agent)
    implements DeviceConnectionsRepository {
  @override
  DeviceAgent? getAgent(DeviceId id) => FakeDeviceAgent(interaction: agent);

  @override
  Stream<List<PluggedDevice>> observePluggedDevices() {
    return Stream.value(const []);
  }

  @override
  Stream<List<DeviceConnection>> observeDeviceConnections() => const .empty();

  @override
  bool isConnected(DeviceId id) => false;

  @override
  Stream<Map<DeviceId, DeviceConnectionState>> observeConnectionStates() {
    return Stream.value(const {});
  }

  @override
  Future<void> toggleConnection(PluggedDevice device) async {}

  @override
  Future<void> dispose() async {}
}
