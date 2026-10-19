import 'package:synk_ui/synk_ui.dart';
import 'package:synk/feat_device_frame/presentation/device_frame_metrics.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_frame/application/file_picker.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_factory_impl.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_factory.dart';
import 'package:synk/feat_device_frame/presentation/device_frame.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clock/clock.dart';
import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';

import '../support/fake_device_session.dart';
import '../support/fake_host_clipboard.dart';

import '../support/fake_settings_repository.dart';

void main() {
  group('DeviceFrame', () {
    testWidgets('mirrors a device without distorting it', (tester) async {
      const shapes = [
        DeviceScreenSize(width: 1080, height: 2400), // 9:20 phone
        DeviceScreenSize(width: 1080, height: 2340), // 9:19.5 phone
        DeviceScreenSize(width: 2560, height: 1600), // landscape tablet
      ];

      for (final shape in shapes) {
        final mirror = await _layOutMirror(tester, shape);

        expect(
          mirror.width / mirror.height,
          closeTo(shape.width / shape.height, 0.001),
          reason: '$shape came out stretched',
        );
      }
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
          lessThanOrEqualTo(DeviceFrameMetrics.referenceWidth + 0.01),
          reason: '$size is wider than its cell',
        );
        expect(
          mirror.height + DeviceFrameMetrics.toolBarHeight,
          lessThanOrEqualTo(DeviceFrameMetrics.height + 0.01),
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

      expect(mirror.width, closeTo(DeviceFrameMetrics.referenceWidth, 0.01));
    });

    testWidgets('leaves an unfocused device on the plain card outline', (
      tester,
    ) async {
      final colors = await _pumpFrame(tester, _referenceScreenSize);

      expect(
        _frameBorderOf(tester).top.color.toARGB32(),
        colors.line.toARGB32(),
      );
    });

    testWidgets('marks the device that receives keystrokes', (tester) async {
      final colors = await _pumpFrame(tester, _referenceScreenSize);

      await tester.tap(find.byType(Texture));
      await tester.pumpAndSettle();

      expect(
        _frameBorderOf(tester).top.color.toARGB32(),
        colors.accent.toARGB32(),
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
        colors.accent.toARGB32(),
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

    testWidgets(
      'hides interaction-only controls for a non-interactive device',
      (
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
      },
    );

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

    testWidgets('lets ⌘, past a focused frame instead of typing it', (
      tester,
    ) async {
      final reachedTheCanvas = <KeyEvent>[];
      await _pumpFrame(
        tester,
        _referenceScreenSize,
        onKeyEscapedFrame: reachedTheCanvas.add,
      );

      await tester.tap(find.byType(Texture));
      await tester.pumpAndSettle();
      reachedTheCanvas.clear();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.comma);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);

      expect(
        reachedTheCanvas.map((event) => event.logicalKey),
        contains(LogicalKeyboardKey.comma),
        reason: 'Synk owns ⌘, — it must not be mirrored to the device',
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

Future<SynkUiColors> _pumpFrame(
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
      DeviceFrameMetrics.referenceWidth + 100,
      DeviceFrameMetrics.height + 100,
    ),
  );
  addTearDown(() => tester.binding.setSurfaceSize(null));

  late SynkUiColors colors;

  await tester.pumpWidget(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NotificationService>(
          create: (_) => NotificationService(),
          dispose: (service) => service.dispose(),
        ),
        RepositoryProvider<ScreenCaptureEventChannel>(
          create: (_) => ScreenCaptureEventChannel(),
          dispose: (channel) => channel.dispose(),
        ),
        RepositoryProvider<DeviceFrameFactory>(
          create: (context) => DeviceFrameFactoryImpl(
            settingsRepository: FakeSettingsRepository(),
            screenCaptureEventChannel: context
                .read<ScreenCaptureEventChannel>(),
            hostClipboard: FakeHostClipboard(),
            filePicker: const SystemFilePicker(),
            fileSystem: MemoryFileSystem(),
            clock: const Clock(),
          ),
        ),
      ],
      child: WidgetsApp(
        color: const SynkUiColors.dark().accent,
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
          return PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          );
        },
        home: SynkUiTheme(
          data: SynkUiThemeData.dark,
          child: DefaultTextStyle(
            style: SynkUiThemeData.dark.typography.body,
            child: Builder(
              builder: (context) {
                colors = context.synkUi.colors;

                return Focus(
                  autofocus: true,
                  onKeyEvent: (_, event) {
                    onKeyEscapedFrame?.call(event);
                    return KeyEventResult.handled;
                  },
                  child: Center(
                    child: SizedBox(
                      width: DeviceFrameMetrics.referenceWidth,
                      height: DeviceFrameMetrics.height,
                      child: DeviceFrame(
                        connection: DeviceConnection(
                          device: _device,
                          session: supportsInteraction
                              ? FakeDeviceSession(
                                  interaction: FakeInteraction(
                                    supportedNavigations: DeviceNavigation
                                        .values
                                        .toSet(),
                                  ),
                                  fileTransfer: const FakeFileTransfer(),
                                  audio: FakeAudio(),
                                )
                              : FakeDeviceSession(),
                          screenSize: screenSize,
                        ),
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

Finder _screenshotIcon() => find.byWidgetPredicate(
  (widget) => widget is Icon && widget.icon == CupertinoIcons.camera,
);

BoxDecoration _frameDecorationOf(WidgetTester tester) {
  final decorated = tester
      .widgetList<DecoratedBox>(
        find.descendant(
          of: find.byType(SynkUiCard),
          matching: find.byType(DecoratedBox),
        ),
      )
      .map((box) => box.decoration as BoxDecoration)
      .firstWhere((decoration) => decoration.border != null);

  return decorated;
}

Border _frameBorderOf(WidgetTester tester) =>
    _frameDecorationOf(tester).border! as Border;
