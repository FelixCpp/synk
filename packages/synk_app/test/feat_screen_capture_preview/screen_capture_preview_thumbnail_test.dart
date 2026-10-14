import 'dart:typed_data';

import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_event.dart';
import 'package:synk/feat_screen_capture_preview/presentation/screen_capture_preview_thumbnail.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// A 1x1 PNG, enough for the widget tree to lay a capture out.
final _png = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

ScreenCaptureEvent _capture(String device, DeviceScreenSize screenSize) {
  return ScreenCaptureEvent.png(
    bytes: _png,
    filepath: '/tmp/screenshot_$device.png',
    screenSize: screenSize,
    deviceId: DeviceId(device),
    modelName: 'Model $device',
  );
}

Future<ScreenCaptureEventChannel> _pumpCorner(WidgetTester tester) async {
  final channel = ScreenCaptureEventChannel();
  addTearDown(channel.dispose);

  await tester.pumpWidget(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NotificationService>(
          create: (_) => NotificationService(),
          dispose: (service) => service.dispose(),
        ),
        RepositoryProvider<ScreenCaptureEventChannel>.value(value: channel),
      ],
      child: CupertinoApp(
        home: SynkUiTheme(
          data: SynkUiThemeData.dark,
          child: const Align(
            alignment: Alignment.bottomRight,
            child: ScreenCapturePreviewThumbnail(),
          ),
        ),
      ),
    ),
  );

  return channel;
}

void main() {
  const portrait = DeviceScreenSize(width: 1080, height: 2400);
  const landscape = DeviceScreenSize(width: 2400, height: 1080);

  testWidgets('stays out of the way until something was captured', (
    tester,
  ) async {
    await _pumpCorner(tester);

    expect(find.byType(Image), findsNothing);
  });

  testWidgets('piles captures from several devices up', (tester) async {
    final channel = await _pumpCorner(tester);

    channel.submit(_capture('a', portrait));
    channel.submit(_capture('b', landscape));
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsNWidgets(2));
    expect(
      find.text('Model b'),
      findsOneWidget,
      reason: 'the front capture has to name the device it came from',
    );
  });

  testWidgets('keeps the pile the size of its largest capture', (
    tester,
  ) async {
    final channel = await _pumpCorner(tester);

    channel.submit(_capture('a', landscape));
    await tester.pumpAndSettle();
    final alone = tester.getSize(find.byType(ScreenCapturePreviewThumbnail));

    channel.submit(_capture('b', portrait));
    await tester.pumpAndSettle();
    final piled = tester.getSize(find.byType(ScreenCapturePreviewThumbnail));

    expect(
      piled.width,
      closeTo(alone.width, 0.01),
      reason: 'a card sliding behind must not push the corner around',
    );
  });

  testWidgets('drops a capture that was dismissed', (tester) async {
    final channel = await _pumpCorner(tester);

    channel.submit(_capture('a', portrait));
    channel.submit(_capture('b', portrait));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(CupertinoIcons.xmark));
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Model a'), findsOneWidget);
  });
}
