import 'package:bench_ui/bench_ui.dart';
import 'package:device_viewer/design/build_context.dart';
import 'package:device_viewer/design/theme/device_viewer_colors.dart';
import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:device_viewer/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:device_viewer/feat_device_agent/application/android_device_agent.dart';
import 'package:device_viewer/feat_device_agent/application/ios_device_agent.dart';
import 'package:device_viewer/feat_device_agent/domain/models/screen_capture_agent.dart';
import 'package:device_viewer/feat_device_connections/domain/models/device_connection.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:device_viewer/feat_device_frame/presentation/device_frame.dart';
import 'package:device_viewer/feat_notifications/application/notification_service.dart';
import 'package:device_viewer/feat_native_texture/native_texture.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device_connection.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device_state.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeviceFrame', () {
    testWidgets('mirrors a 9:20 device without distorting it', (tester) async {
      final mirror = await _layOutMirror(
        tester,
        const DeviceScreenSize(width: 1080, height: 2400),
      );

      expect(mirror.width / mirror.height, closeTo(1080 / 2400, 0.001));
    });

    testWidgets('mirrors a 9:19.5 device without distorting it', (
      tester,
    ) async {
      final mirror = await _layOutMirror(
        tester,
        const DeviceScreenSize(width: 1080, height: 2340),
      );

      expect(mirror.width / mirror.height, closeTo(1080 / 2340, 0.001));
    });

    testWidgets('mirrors a landscape tablet without distorting it', (
      tester,
    ) async {
      final mirror = await _layOutMirror(
        tester,
        const DeviceScreenSize(width: 2560, height: 1600),
      );

      expect(mirror.width / mirror.height, closeTo(2560 / 1600, 0.001));
    });

    testWidgets('never exceeds the cell it was given', (tester) async {
      for (final size in const [
        DeviceScreenSize(width: 1080, height: 2400),
        DeviceScreenSize(width: 1080, height: 2340),
        DeviceScreenSize(width: 1440, height: 3120),
        DeviceScreenSize(width: 2560, height: 1600),
        DeviceScreenSize(width: 800, height: 1600),
      ]) {
        final mirror = await _layOutMirror(tester, size);

        expect(
          mirror.width,
          lessThanOrEqualTo(DeviceViewerTheme.deviceFrameWidth + 0.01),
          reason: '$size is wider than its cell',
        );
        expect(
          mirror.height + DeviceViewerTheme.deviceFrameToolBarHeight,
          lessThanOrEqualTo(DeviceViewerTheme.deviceFrameHeight + 0.01),
          reason: '$size is taller than its cell',
        );
      }
    });

    testWidgets('fills the cell width for the reference device shape', (
      tester,
    ) async {
      // 9:20 is what the cell is dimensioned for, so such a device should
      // not be shrunk at all.
      final mirror = await _layOutMirror(
        tester,
        const DeviceScreenSize(width: 900, height: 2000),
      );

      expect(mirror.width, closeTo(DeviceViewerTheme.deviceFrameWidth, 0.01));
    });

    testWidgets('leaves an unfocused device on the plain card outline', (
      tester,
    ) async {
      final colors = await _pumpFrame(tester, _referenceScreenSize);

      expect(
        _frameBorderOf(tester).top.color.toARGB32(),
        colors.divider.toARGB32(),
      );
    });

    testWidgets('marks the device that receives keystrokes', (tester) async {
      final colors = await _pumpFrame(tester, _referenceScreenSize);

      await tester.tap(find.byType(Texture));
      await tester.pumpAndSettle();

      expect(
        _frameBorderOf(tester).top.color.toARGB32(),
        colors.focusRing.toARGB32(),
      );
    });

    testWidgets('takes focus from a swipe, not just from a tap', (
      tester,
    ) async {
      final colors = await _pumpFrame(tester, _referenceScreenSize);

      final mirror = tester.getCenter(find.byType(Texture));
      final gesture = await tester.startGesture(mirror);
      await gesture.moveBy(const Offset(0.0, -120.0));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(
        _frameBorderOf(tester).top.color.toARGB32(),
        colors.focusRing.toARGB32(),
      );
    });

    testWidgets('always shows the action icons, hovered or not', (
      tester,
    ) async {
      await _pumpFrame(tester, _referenceScreenSize);

      expect(_screenshotIcon(), findsOneWidget);
    });

    testWidgets('never hides the device it belongs to', (tester) async {
      await _pumpFrame(tester, _referenceScreenSize);

      expect(
        find.text(_device.modelName),
        findsOneWidget,
        reason: 'the model name has to stay readable without hovering',
      );
    });

    testWidgets('hides interaction-only controls for a non-interactive device', (
      tester,
    ) async {
      await _pumpFrame(
        tester,
        _referenceScreenSize,
        supportsInteraction: false,
      );

      expect(find.byIcon(CupertinoIcons.home), findsNothing);
      expect(find.byIcon(CupertinoIcons.ellipsis_vertical), findsNothing);
      expect(_screenshotIcon(), findsOneWidget);
    });

    testWidgets('forwards keystrokes only while focused', (tester) async {
      final reachedTheCanvas = <KeyEvent>[];
      await _pumpFrame(
        tester,
        _referenceScreenSize,
        onKeyEscapedFrame: reachedTheCanvas.add,
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
      expect(reachedTheCanvas, isNotEmpty);
      reachedTheCanvas.clear();

      await tester.tap(find.byType(Texture));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA);

      expect(
        reachedTheCanvas,
        isEmpty,
        reason: 'a focused frame has to swallow the keystroke and mirror it',
      );
    });
  });
}

const _device = AndroidDevice(
  id: DeviceId('test-device'),
  modelName: 'Test Device',
  state: AndroidDeviceState.device,
  connection: AndroidDeviceConnection.usb,
);

const _referenceScreenSize = DeviceScreenSize(width: 1080, height: 2400);

/// Lays a [DeviceFrame] out in a cell the size the grid gives it and returns
/// the size the mirrored picture ends up with - the part that has to match
/// the device's shape.
Future<Size> _layOutMirror(
  WidgetTester tester,
  DeviceScreenSize screenSize,
) async {
  await _pumpFrame(tester, screenSize);

  return tester.getSize(find.byType(Texture));
}

Future<DeviceViewerColors> _pumpFrame(
  WidgetTester tester,
  DeviceScreenSize screenSize, {
  ValueChanged<KeyEvent>? onKeyEscapedFrame,
  bool isMaximized = false,
  bool supportsInteraction = true,
}) async {
  // The default test surface is shorter than a cell, which would silently
  // squash the frame and make every assertion here meaningless.
  await tester.binding.setSurfaceSize(
    const Size(
      DeviceViewerTheme.deviceFrameWidth + 100,
      DeviceViewerTheme.deviceFrameHeight + 100,
    ),
  );
  addTearDown(() => tester.binding.setSurfaceSize(null));

  late DeviceViewerColors colors;

  await tester.pumpWidget(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DeviceConnectionsRepository>.value(
          value: _OfflineConnections(),
        ),
        RepositoryProvider<NotificationService>(
          create: (_) => NotificationService(),
          dispose: (service) => service.dispose(),
        ),
      ],
      child: WidgetsApp(
        color: const BenchColors.dark().accent,
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
          return PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          );
        },
        home: BenchTheme(
          data: BenchThemeData.dark,
          child: DefaultTextStyle(
            style: BenchThemeData.dark.typography.body,
            child: Builder(
              builder: (context) {
                colors = context.colors;

                return Focus(
                  autofocus: true,
                  onKeyEvent: (_, event) {
                    onKeyEscapedFrame?.call(event);
                    return KeyEventResult.handled;
                  },
                  child: Center(
                    child: SizedBox(
                      width: DeviceViewerTheme.deviceFrameWidth,
                      height: DeviceViewerTheme.deviceFrameHeight,
                      child: DeviceFrame(
                        deviceId: _device.id,
                        modelName: _device.modelName,
                        isLive: true,
                        textureId: const NativeTextureId(1),
                        screenSize: screenSize,
                        supportsInteraction: supportsInteraction,
                        isMaximized: isMaximized,
                        onToggleMaximize: () {},
                        onClose: () {},
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ),
  );

  return colors;
}

class _OfflineConnections implements DeviceConnectionsRepository {
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

Finder _screenshotIcon() => find.byWidgetPredicate(
  (widget) => widget is Icon && widget.icon == CupertinoIcons.camera,
);

BoxDecoration _frameDecorationOf(WidgetTester tester) {
  final decorated = tester
      .widgetList<DecoratedBox>(
        find.descendant(
          of: find.byType(BenchCard),
          matching: find.byType(DecoratedBox),
        ),
      )
      .map((box) => box.decoration as BoxDecoration)
      .firstWhere((decoration) => decoration.border != null);

  return decorated;
}

Border _frameBorderOf(WidgetTester tester) =>
    _frameDecorationOf(tester).border! as Border;
