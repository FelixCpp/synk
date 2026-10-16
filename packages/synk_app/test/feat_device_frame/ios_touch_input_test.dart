import 'package:api_devicectl/api_devicectl.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform_ios/ios_device_session.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_hid_channel.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_channel.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_transport.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_touch_gesture.dart';
import 'package:synk/feat_device_frame/application/file_picker.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository_impl.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clock/clock.dart';
import 'package:file/memory.dart';
import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';

import '../support/fake_device_session.dart';
import '../support/fake_host_clipboard.dart';
import '../support/fake_settings_repository.dart';

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

  group('the gesture behind a navigation', () {
    test('leaves the bottom edge for home', () {
      final swipe = iosSwipeForNavigation(.home);

      expect(swipe.edge, IosTouchEdge.bottom);
      expect(swipe.from.y, 1.0);
      expect(swipe.to.y, lessThan(swipe.from.y));
      expect(swipe.hold, Duration.zero);
    });

    test('holds at the top for the app switcher', () {
      final swipe = iosSwipeForNavigation(.appSwitch);

      expect(swipe.edge, IosTouchEdge.bottom);
      expect(swipe.hold, greaterThan(Duration.zero));
    });

    test('comes in from the left edge for back', () {
      final swipe = iosSwipeForNavigation(.back);

      expect(swipe.edge, IosTouchEdge.left);
      expect(swipe.from.x, 0.0);
      expect(swipe.to.x, greaterThan(swipe.from.x));
    });
  });

  group('the iOS session', () {
    late List<MethodCall> calls;
    late IosDeviceSession session;
    late DeviceInteraction interaction;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      calls = [];

      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

      messenger.setMockMethodCallHandler(
        const MethodChannel('dev.synk/ios_hid'),
        (call) async {
          calls.add(call);
          return null;
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

      session = IosDeviceSession(
        transport: IosMirrorTransport(IosMirrorChannel(), null),
        hidChannel: IosHidChannel(),
        devicectl: DevicectlApi(),
        fileSystem: MemoryFileSystem(),
        deviceId: _deviceId,
        textureId: const NativeTextureId(1),
        initialScreenSize: const DeviceScreenSize(width: 1179, height: 2556),
        interactionUnavailableReason: null,
      );

      interaction = session.interaction!;

      // The constructor fires an unawaited orientation refresh so a device
      // that is already in landscape when mirroring starts is handled
      // correctly. Let it settle before each test records its own calls.
      await pumpEventQueue();
      calls.clear();
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
      await interaction.simulatePointerEvent(_pointer(.down, 0.4, 0.6));
      await interaction.simulatePointerEvent(_pointer(.up, 0.4, 0.6));

      expect(calls.map((call) => call.method), ['sendTouch', 'sendTouch']);
      expect(calls.first.arguments['phase'], 'start');
      expect(calls.last.arguments['phase'], 'end');
      expect(calls.first.arguments['x'], 0.4);
      expect(calls.first.arguments['y'], 0.6);
      expect(calls.first.arguments['deviceId'], _deviceId.value);
    });

    test('keeps a single finger out of the two-finger path', () async {
      await interaction.simulatePointerEvent(_pointer(.down, 0.5, 0.5));

      expect(calls.single.arguments.containsKey('secondX'), isFalse);
    });

    test(
      'holds the edge of a gesture from its first event to its last',
      () async {
        await interaction.simulatePointerEvent(_pointer(.down, 0.5, 1.0));
        await interaction.simulatePointerEvent(_pointer(.move, 0.5, 0.7));
        await interaction.simulatePointerEvent(_pointer(.up, 0.5, 0.35));

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
      await interaction.simulatePointerEvent(_pointer(.down, 0.5, 1.0));
      await interaction.simulatePointerEvent(_pointer(.up, 0.5, 0.4));
      calls.clear();

      await interaction.simulatePointerEvent(_pointer(.down, 0.5, 0.5));

      expect(calls.single.arguments['edge'], 'none');
    });

    test(
      'scripts a navigation as one swipe, not as single events',
      () async {
        await interaction.navigate(.home);

        expect(calls.single.method, 'sendSwipe');
        expect(calls.single.arguments['edge'], 'bottom');
        expect(calls.single.arguments['fromY'], 1.0);
      },
    );

    test('presses the sleep button for power, rather than swiping', () async {
      await interaction.pressPowerButton();

      expect(calls.single.method, 'pressButton');
      expect(calls.single.arguments['usagePage'], 0x0c);
      expect(calls.single.arguments['usageCode'], 0x30);
    });

    test('spreads a pinch into two fingers around its center', () async {
      await interaction.simulatePinchEvent((
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
        await interaction.simulatePinchEvent((
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
      await interaction.simulateKeyEvent(
        const DeviceKeyEvent(
          key: LogicalKeyboardKey.keyA,
          physicalKey: PhysicalKeyboardKey.keyA,
          type: DeviceKeyEventType.down,
          modifiers: {},
        ),
      );
      await interaction.simulateKeyEvent(
        const DeviceKeyEvent(
          key: LogicalKeyboardKey.keyA,
          physicalKey: PhysicalKeyboardKey.keyA,
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
      await interaction.simulateKeyEvent(
        const DeviceKeyEvent(
          key: LogicalKeyboardKey.fn,
          physicalKey: PhysicalKeyboardKey.fn,
          type: DeviceKeyEventType.down,
          modifiers: {},
        ),
      );

      expect(calls, isEmpty);
    });

    test(
      'sends where a key sits, so a German colon is the period key',
      () async {
        // Shift and the period key type `:` on a German layout. The device
        // applies its own layout to the position, as with a real keyboard.
        await interaction.simulateKeyEvent(
          const DeviceKeyEvent(
            key: LogicalKeyboardKey.colon,
            physicalKey: PhysicalKeyboardKey.period,
            type: DeviceKeyEventType.down,
            modifiers: {DeviceKeyModifier.shiftLeft},
            character: ':',
          ),
        );

        expect(calls.single.arguments['usage'], 0x37);
      },
    );

    test(
      'sends an umlaut key that has no character of its own on US',
      () async {
        // `ö` sits where US keyboards have the semicolon.
        await interaction.simulateKeyEvent(
          const DeviceKeyEvent(
            key: LogicalKeyboardKey(0xf6),
            physicalKey: PhysicalKeyboardKey.semicolon,
            type: DeviceKeyEventType.down,
            modifiers: {},
            character: 'ö',
          ),
        );

        expect(calls.single.arguments['usage'], 0x33);
      },
    );

    test('releases the device input when it shuts down', () async {
      await session.dispose();

      expect(
        calls.map((call) => call.method),
        contains('releaseInput'),
      );
    });
  });

  group('orientation refresh', () {
    late List<MethodCall> calls;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      calls = [];

      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

      messenger.setMockMethodCallHandler(
        const MethodChannel('dev.synk/ios_hid'),
        (call) async {
          calls.add(call);
          return null;
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

    test(
      'is requested as soon as a device that takes input connects, so a '
      'device already in landscape is handled from the first touch',
      () async {
        IosDeviceSession(
          transport: IosMirrorTransport(IosMirrorChannel(), null),
          hidChannel: IosHidChannel(),
          devicectl: DevicectlApi(),
          fileSystem: MemoryFileSystem(),
          deviceId: _deviceId,
          textureId: const NativeTextureId(1),
          initialScreenSize: const DeviceScreenSize(width: 1179, height: 2556),
          interactionUnavailableReason: null,
        );

        await pumpEventQueue();

        expect(
          calls.map((call) => call.method),
          contains('refreshOrientation'),
        );
        expect(
          calls
              .firstWhere((call) => call.method == 'refreshOrientation')
              .arguments['deviceId'],
          _deviceId.value,
        );
      },
    );

    test('is not requested for a device that takes no input', () async {
      IosDeviceSession(
        transport: IosMirrorTransport(IosMirrorChannel(), null),
        hidChannel: IosHidChannel(),
        devicectl: DevicectlApi(),
        fileSystem: MemoryFileSystem(),
        deviceId: _deviceId,
        textureId: const NativeTextureId(1),
        initialScreenSize: const DeviceScreenSize(width: 1179, height: 2556),
        interactionUnavailableReason: .unknown,
      );

      await pumpEventQueue();

      expect(calls, isEmpty);
    });
  });

  group('the frame repository', () {
    test('passes navigation and the power button on to the device', () async {
      final interaction = _RecordingInteraction();
      final repository = DeviceFrameRepositoryImpl(
        deviceId: _deviceId,
        modelName: 'Test Device',
        session: FakeDeviceSession(interaction: interaction),
        settingsRepository: FakeSettingsRepository(),
        screenCaptureEventChannel: ScreenCaptureEventChannel(),
        hostClipboard: FakeHostClipboard(),
        filePicker: const SystemFilePicker(),
        fileSystem: MemoryFileSystem(),
        clock: const Clock(),
      );

      await repository.navigate(.back);
      await repository.navigate(.home);
      await repository.navigate(.appSwitch);
      await repository.pressPowerButton();

      expect(interaction.navigations, [
        DeviceNavigation.back,
        DeviceNavigation.home,
        DeviceNavigation.appSwitch,
      ]);
      expect(interaction.powerButtonPresses, 1);
    });

    test('drops input for a device that does not take any', () async {
      final repository = DeviceFrameRepositoryImpl(
        deviceId: _deviceId,
        modelName: 'Test Device',
        session: FakeDeviceSession(),
        settingsRepository: FakeSettingsRepository(),
        screenCaptureEventChannel: ScreenCaptureEventChannel(),
        hostClipboard: FakeHostClipboard(),
        filePicker: const SystemFilePicker(),
        fileSystem: MemoryFileSystem(),
        clock: const Clock(),
      );

      await repository.simulatePointerEvent(
        _pointer(.down, 0.5, 0.5),
      );
      await repository.navigate(.home);
      await repository.pressPowerButton();
    });
  });
}

class _RecordingInteraction implements DeviceInteraction {
  final navigations = <DeviceNavigation>[];
  var powerButtonPresses = 0;
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
  Set<DeviceNavigation> get supportedNavigations => const {};

  @override
  Future<void> navigate(DeviceNavigation navigation) async {
    navigations.add(navigation);
  }

  @override
  Future<void> pressPowerButton() async {
    powerButtonPresses++;
  }
}
