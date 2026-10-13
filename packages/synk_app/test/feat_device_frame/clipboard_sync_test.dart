import 'package:synk/feat_device_platform/application/device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/clipboard_device_agent.dart';
import 'package:synk/feat_device_platform/domain/models/device_key_event.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:api_devicectl/api_devicectl.dart';
import 'package:synk/feat_device_frame/domain/models/clipboard_sync_failure.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_device_agent.dart';

const _deviceId = DeviceId('00008120-0009555001C2601E');

DeviceKeyEvent _shortcut(
  LogicalKeyboardKey key, {
  DeviceKeyEventType type = DeviceKeyEventType.down,
  bool withMeta = true,
}) {
  return DeviceKeyEvent(
    key: key,
    type: type,
    modifiers: withMeta ? const {DeviceKeyModifier.metaLeft} : const {},
  );
}

void main() {
  late _FakeClipboardAgent agent;
  late DeviceFrameRepository repository;
  String? hostClipboard;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    agent = _FakeClipboardAgent();
    repository = DeviceFrameRepository(
      repository: _ConnectionsWithClipboard(agent),
    );
    hostClipboard = null;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          switch (call.method) {
            case 'Clipboard.getData':
              return hostClipboard == null ? null : {'text': hostClipboard};
            case 'Clipboard.setData':
              hostClipboard = (call.arguments as Map)['text'] as String?;
              return null;
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  group('clipboard shortcuts', () {
    test('copy pulls the device clipboard onto the host', () async {
      agent.content = 'from the device';

      await repository.simulateKeyEvent(
        _deviceId,
        _shortcut(LogicalKeyboardKey.keyC),
      );

      expect(agent.reads, 1);
      expect(hostClipboard, 'from the device');
    });

    test('paste pushes the host clipboard onto the device', () async {
      hostClipboard = 'from the host';

      await repository.simulateKeyEvent(
        _deviceId,
        _shortcut(LogicalKeyboardKey.keyV),
      );

      expect(agent.content, 'from the host');
    });

    test('syncs once per shortcut, on the key down', () async {
      agent.content = 'from the device';

      await repository.simulateKeyEvent(
        _deviceId,
        _shortcut(LogicalKeyboardKey.keyC, type: .up),
      );
      await repository.simulateKeyEvent(
        _deviceId,
        _shortcut(LogicalKeyboardKey.keyC, type: .repeat),
      );

      expect(agent.reads, 0);
      expect(hostClipboard, isNull);
    });

    test(
      'leaves the host clipboard alone when the device has no text',
      () async {
        hostClipboard = 'keep me';
        agent.content = '';

        await repository.simulateKeyEvent(
          _deviceId,
          _shortcut(LogicalKeyboardKey.keyC),
        );

        expect(hostClipboard, 'keep me');
      },
    );

    test(
      'leaves the device clipboard alone when the host has no text',
      () async {
        agent.content = 'keep me';

        await repository.simulateKeyEvent(
          _deviceId,
          _shortcut(LogicalKeyboardKey.keyV),
        );

        expect(agent.content, 'keep me');
      },
    );

    test('reports a device clipboard it cannot reach', () async {
      agent.isReachable = false;
      hostClipboard = 'keep me';

      final copy = await repository.simulateKeyEvent(
        _deviceId,
        _shortcut(LogicalKeyboardKey.keyC),
      );
      final paste = await repository.simulateKeyEvent(
        _deviceId,
        _shortcut(LogicalKeyboardKey.keyV),
      );

      expect(copy, ClipboardSyncFailure.deviceUnreachable);
      expect(paste, ClipboardSyncFailure.deviceUnreachable);
      expect(hostClipboard, 'keep me');
    });

    test('reports a missing devicectl as an unavailable tool', () async {
      agent.failure = const DevicectlCommandException(message: 'no xcode');
      hostClipboard = 'text';

      final failure = await repository.simulateKeyEvent(
        _deviceId,
        _shortcut(LogicalKeyboardKey.keyV),
      );

      expect(failure, ClipboardSyncFailure.toolUnavailable);
    });

    test('ignores the keys without the meta modifier', () async {
      agent.content = 'from the device';

      await repository.simulateKeyEvent(
        _deviceId,
        _shortcut(LogicalKeyboardKey.keyC, withMeta: false),
      );

      expect(agent.reads, 0);
      expect(hostClipboard, isNull);
    });
  });
}

class _FakeClipboardAgent implements ClipboardDeviceAgent {
  String content = '';
  int reads = 0;
  bool isReachable = true;
  Object? failure;

  @override
  Future<String> getClipboard() async {
    reads++;
    if (!isReachable || failure != null) {
      throw failure ?? Exception('no pasteboard on this device');
    }

    return content;
  }

  @override
  Future<void> setClipboard(String clipboard) async {
    if (!isReachable || failure != null) {
      throw failure ?? Exception('no pasteboard on this device');
    }

    content = clipboard;
  }
}

class _ConnectionsWithClipboard(final ClipboardDeviceAgent agent)
    implements DeviceConnectionsRepository {
  @override
  DeviceAgent? getAgent(DeviceId id) => FakeDeviceAgent(clipboard: agent);

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
