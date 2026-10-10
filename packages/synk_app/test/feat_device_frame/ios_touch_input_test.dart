import 'package:api_devicectl/api_devicectl.dart';
import 'package:synk/feat_device_agent/application/android_device_agent.dart';
import 'package:synk/feat_device_agent/application/ios_device_agent.dart';
import 'package:synk/feat_device_agent/data/datasources/ios_hid_channel.dart';
import 'package:synk/feat_device_agent/data/datasources/ios_mirror_channel.dart';
import 'package:synk/feat_device_agent/domain/models/clipboard_agent.dart';
import 'package:synk/feat_device_agent/domain/models/device_key_event.dart';
import 'package:synk/feat_device_agent/domain/models/device_pointer_event.dart';
import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_agent/domain/models/interaction_agent.dart';
import 'package:synk/feat_device_agent/domain/models/ios_touch_gesture.dart';
import 'package:synk/feat_device_agent/domain/models/screen_capture_agent.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository_impl.dart';
import 'package:synk/feat_mirror_session/mirror_session.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _deviceId = DeviceId('00008120-0009555001C2601E');

DevicePointerEvent _pointer(
  DevicePointerEventType type,
  double x,
  double y,
) {
  return DevicePointerEvent(
    type: type,
    normalizedPointerX: x,
    normalizedPointerY: y,
  );
}

void main() {
  group('the edge a gesture starts at', () {
    test('is none in the middle of the screen', () {
      expect(iosTouchEdgeAtPointerDown(0.5, 0.5), IosTouchEdge.none);
    });

    test('is the bottom for the home indicator strip', () {
      expect(iosTouchEdgeAtPointerDown(0.5, 1.0), IosTouchEdge.bottom);
      expect(iosTouchEdgeAtPointerDown(0.5, 0.99), IosTouchEdge.bottom);
    });

    test('leaves a tap just above the strip alone', () {
      expect(iosTouchEdgeAtPointerDown(0.5, 0.95), IosTouchEdge.none);
    });

    test('is the side for the left and right strips', () {
      expect(iosTouchEdgeAtPointerDown(0.0, 0.5), IosTouchEdge.left);
      expect(iosTouchEdgeAtPointerDown(1.0, 0.5), IosTouchEdge.right);
    });

    test('is the bottom in the bottom corners', () {
      expect(iosTouchEdgeAtPointerDown(0.0, 1.0), IosTouchEdge.bottom);
      expect(iosTouchEdgeAtPointerDown(1.0, 1.0), IosTouchEdge.bottom);
    });
  });

  group('the gesture behind a control action', () {
    test('leaves the bottom edge for home', () {
      final swipe = iosSwipeForControlAction(.home)!;

      expect(swipe.edge, IosTouchEdge.bottom);
      expect(swipe.from.y, 1.0);
      expect(swipe.to.y, lessThan(swipe.from.y));
      expect(swipe.hold, Duration.zero);
    });

    test('holds at the top for the app switcher', () {
      final swipe = iosSwipeForControlAction(.appSwitch)!;

      expect(swipe.edge, IosTouchEdge.bottom);
      expect(swipe.hold, greaterThan(Duration.zero));
    });

    test('comes in from the left edge for back', () {
      final swipe = iosSwipeForControlAction(.back)!;

      expect(swipe.edge, IosTouchEdge.left);
      expect(swipe.from.x, 0.0);
      expect(swipe.to.x, greaterThan(swipe.from.x));
    });

    test('does not exist for standby', () {
      expect(iosSwipeForControlAction(.standby), isNull);
    });
  });

  group('the iOS agent', () {
    late List<MethodCall> calls;
    late IosDeviceAgent agent;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      calls = [];

      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

      messenger.setMockMethodCallHandler(
        const MethodChannel('dev.synk/ios_hid'),
        (call) async {
          calls.add(call);
          return call.method == 'prepareInput' ? true : null;
        },
      );

      messenger.setMockMethodCallHandler(
        const MethodChannel('dev.synk/ios_mirror/screen_size'),
        (call) async => null,
      );
      messenger.setMockMethodCallHandler(
        const MethodChannel('dev.synk/ios_mirror'),
        (call) async => null,
      );

      agent = IosDeviceAgent(
        IosMirrorChannel(),
        IosHidChannel(),
        DevicectlApi(),
        _deviceId,
        const NativeTextureId(1),
        const DeviceScreenSize(width: 1179, height: 2556),
        true,
      );
    });

    tearDown(() {
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

      messenger.setMockMethodCallHandler(
        const MethodChannel('dev.synk/ios_hid'),
        null,
      );
      messenger.setMockMethodCallHandler(
        const MethodChannel('dev.synk/ios_mirror/screen_size'),
        null,
      );
      messenger.setMockMethodCallHandler(
        const MethodChannel('dev.synk/ios_mirror'),
        null,
      );
    });

    test('sends a tap as a start and an end at the same point', () async {
      await agent.simulatePointerEvent(_pointer(.down, 0.4, 0.6));
      await agent.simulatePointerEvent(_pointer(.up, 0.4, 0.6));

      expect(calls.map((call) => call.method), ['sendTouch', 'sendTouch']);
      expect(calls.first.arguments['phase'], 'start');
      expect(calls.last.arguments['phase'], 'end');
      expect(calls.first.arguments['x'], 0.4);
      expect(calls.first.arguments['y'], 0.6);
      expect(calls.first.arguments['deviceId'], _deviceId.value);
    });

    test('keeps a single finger out of the two-finger path', () async {
      await agent.simulatePointerEvent(_pointer(.down, 0.5, 0.5));

      expect(calls.single.arguments.containsKey('secondX'), isFalse);
    });

    test(
      'holds the edge of a gesture from its first event to its last',
      () async {
        await agent.simulatePointerEvent(_pointer(.down, 0.5, 1.0));
        await agent.simulatePointerEvent(_pointer(.move, 0.5, 0.7));
        await agent.simulatePointerEvent(_pointer(.up, 0.5, 0.35));

        expect(
          calls.map((call) => call.arguments['edge']),
          ['bottom', 'bottom', 'bottom'],
        );
        expect(
          calls.map((call) => call.arguments['phase']),
          ['start', 'move', 'end'],
        );
      },
    );

    test('starts the next gesture with a fresh edge', () async {
      await agent.simulatePointerEvent(_pointer(.down, 0.5, 1.0));
      await agent.simulatePointerEvent(_pointer(.up, 0.5, 0.4));
      calls.clear();

      await agent.simulatePointerEvent(_pointer(.down, 0.5, 0.5));

      expect(calls.single.arguments['edge'], 'none');
    });

    test(
      'scripts a control action as one swipe, not as single events',
      () async {
        await agent.simulateControlAction(.home);

        expect(calls.single.method, 'sendSwipe');
        expect(calls.single.arguments['edge'], 'bottom');
        expect(calls.single.arguments['fromY'], 1.0);
      },
    );

    test('presses the sleep button for standby, rather than swiping', () async {
      await agent.simulateControlAction(.standby);

      expect(calls.single.method, 'pressButton');
      expect(calls.single.arguments['usagePage'], 0x0c);
      expect(calls.single.arguments['usageCode'], 0x30);
    });

    test('spreads a pinch into two fingers around its center', () async {
      await agent.simulatePinchEvent((
        type: DevicePointerEventType.move,
        centerX: 0.5,
        centerY: 0.5,
        spread: 0.1,
      ));

      final arguments = calls.single.arguments;
      expect(calls.single.method, 'sendTouch');
      expect(arguments['x'], closeTo(0.4, 1e-9));
      expect(arguments['secondX'], closeTo(0.6, 1e-9));
      expect(arguments['y'], 0.5);
      expect(arguments['secondY'], 0.5);
      expect(arguments['edge'], 'none');
    });

    test(
      'keeps both fingers on screen when the pinch opens too wide',
      () async {
        await agent.simulatePinchEvent((
          type: DevicePointerEventType.move,
          centerX: 0.5,
          centerY: 0.5,
          spread: 0.9,
        ));

        expect(calls.single.arguments['x'], 0.0);
        expect(calls.single.arguments['secondX'], 1.0);
      },
    );

    test('sends a keystroke as a HID usage code, down then up', () async {
      await agent.simulateKeyEvent(
        const DeviceKeyEvent(
          key: LogicalKeyboardKey.keyA,
          type: DeviceKeyEventType.down,
          modifiers: {},
        ),
      );
      await agent.simulateKeyEvent(
        const DeviceKeyEvent(
          key: LogicalKeyboardKey.keyA,
          type: DeviceKeyEventType.up,
          modifiers: {},
        ),
      );

      expect(calls.map((call) => call.method), ['sendKey', 'sendKey']);
      expect(calls.first.arguments['usage'], 0x04);
      expect(calls.first.arguments['isDown'], isTrue);
      expect(calls.last.arguments['isDown'], isFalse);
    });

    test('says nothing for a key the keyboard page has no code for', () async {
      await agent.simulateKeyEvent(
        const DeviceKeyEvent(
          key: LogicalKeyboardKey.gameButtonA,
          type: DeviceKeyEventType.down,
          modifiers: {},
        ),
      );

      expect(calls, isEmpty);
    });

    test('releases the device input when it shuts down', () async {
      await agent.dispose();

      expect(
        calls.map((call) => call.method),
        contains('releaseInput'),
      );
    });
  });

  group('the frame repository', () {
    test('turns a control button into the matching device action', () async {
      final agent = _RecordingInteractionAgent();
      final repository = DeviceFrameRepositoryImpl(
        repository: _ConnectionsWithInteraction(agent),
      );

      await repository.simulateControlButtonEvent(_deviceId, .back);
      await repository.simulateControlButtonEvent(_deviceId, .home);
      await repository.simulateControlButtonEvent(_deviceId, .appSwitch);
      await repository.simulateControlButtonEvent(_deviceId, .power);

      expect(agent.actions, [
        DeviceControlAction.back,
        DeviceControlAction.home,
        DeviceControlAction.appSwitch,
        DeviceControlAction.standby,
      ]);
    });

    test('drops input for a device that does not take any', () async {
      final repository = DeviceFrameRepositoryImpl(
        repository: _ConnectionsWithInteraction(null),
      );

      await repository.simulatePointerEvent(
        _deviceId,
        _pointer(.down, 0.5, 0.5),
      );
      await repository.simulateControlButtonEvent(_deviceId, .home);
    });
  });
}

class _RecordingInteractionAgent implements InteractionAgent {
  final actions = <DeviceControlAction>[];
  final pointerEvents = <DevicePointerEvent>[];

  @override
  Future<void> simulateKeyEvent(DeviceKeyEvent event) async {}

  @override
  Future<void> simulatePointerEvent(DevicePointerEvent event) async {
    pointerEvents.add(event);
  }

  @override
  Future<void> simulatePinchEvent(PinchEvent event) async {}

  @override
  Future<void> simulateControlAction(DeviceControlAction action) async {
    actions.add(action);
  }
}

class _ConnectionsWithInteraction(final InteractionAgent? agent)
    implements DeviceConnectionsRepository {
  @override
  InteractionAgent? getInteractionAgent(DeviceId id) => agent;

  @override
  ClipboardAgent? getClipboardAgent(DeviceId id) => null;

  @override
  AndroidDeviceAgent? getAndroidDeviceAgent(DeviceId id) => null;

  @override
  IosDeviceAgent? getIosDeviceAgent(DeviceId id) => null;

  @override
  ScreenCaptureAgent? getScreenCaptureAgent(DeviceId id) => null;

  @override
  Stream<List<PluggedDevice>> observeConnectingDevices() => const .empty();

  @override
  Stream<List<DeviceConnection>> observeDeviceConnections() => const .empty();

  @override
  Future<bool> isConnected(DeviceId id) async => false;

  @override
  Future<void> toggleConnection(PluggedDevice device) async {}

  @override
  Future<void> dispose() async {}
}
