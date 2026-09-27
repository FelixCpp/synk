import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:device_viewer/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_canvas/presentation/widgets/device_frame.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device_connection.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device_state.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:macos_ui/macos_ui.dart';

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
  });
}

const _device = AndroidDevice(
  id: DeviceId('test-device'),
  modelName: 'Test Device',
  state: AndroidDeviceState.device,
  connection: AndroidDeviceConnection.usb,
);

/// Lays a [DeviceFrame] out in a cell the size the grid gives it and returns
/// the size the mirrored picture ends up with - the part that has to match
/// the device's shape.
Future<Size> _layOutMirror(
  WidgetTester tester,
  DeviceScreenSize screenSize,
) async {
  // The default test surface is shorter than a cell, which would silently
  // squash the frame and make every assertion here meaningless.
  await tester.binding.setSurfaceSize(
    const Size(
      DeviceViewerTheme.deviceFrameWidth + 100,
      DeviceViewerTheme.deviceFrameHeight + 100,
    ),
  );
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MacosApp(
      home: Center(
        child: SizedBox(
          width: DeviceViewerTheme.deviceFrameWidth,
          height: DeviceViewerTheme.deviceFrameHeight,
          child: DeviceFrame(
            device: CanvasDevice.android(
              device: _device,
              isConnected: true,
              textureId: const NativeTextureId(1),
              screenSize: screenSize,
            ),
            onCaptureScreenshot: (_) {},
            onClose: (_) {},
            onTouch: (_, _, _, _) {},
            mirrorTextureId: 1,
          ),
        ),
      ),
    ),
  );

  return tester.getSize(find.byType(Texture));
}
