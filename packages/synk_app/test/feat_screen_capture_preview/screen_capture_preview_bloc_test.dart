import 'dart:async';
import 'dart:typed_data';

import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_event.dart';
import 'package:synk/feat_screen_capture_preview/domain/repositories/screen_capture_preview_repository.dart';
import 'package:synk/feat_screen_capture_preview/presentation/bloc/screen_capture_preview_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

ScreenCaptureEvent _capture(String device) {
  return ScreenCaptureEvent.png(
    bytes: Uint8List(0),
    filepath: '/tmp/screenshot_$device.png',
    screenSize: const DeviceScreenSize(width: 1080, height: 2400),
    deviceId: DeviceId(device),
    modelName: 'Model $device',
  );
}

class _RecordingRepository implements ScreenCapturePreviewRepository {
  final captures = StreamController<ScreenCaptureEvent>.broadcast();
  final handedToTheSystem = <ScreenCaptureEvent>[];

  @override
  Stream<ScreenCaptureEvent> observeEvents() => captures.stream;

  @override
  Future<void> openInSystemViewer(ScreenCaptureEvent event) async {
    handedToTheSystem.add(event);
  }
}

void main() {
  late _RecordingRepository repository;
  late NotificationService notifications;
  late ScreenCapturePreviewBloc bloc;

  setUp(() {
    repository = _RecordingRepository();
    notifications = NotificationService();
    bloc = ScreenCapturePreviewBloc(repository, notifications);
  });

  tearDown(() async {
    await bloc.close();
    await repository.captures.close();
    await notifications.dispose();
  });

  Future<void> capture(String device) async {
    repository.captures.add(_capture(device));
    await pumpEventQueue();
  }

  Future<void> press(ScreenCaptureEvent event) async {
    bloc.add(.onPreviewPressed(event));
    await pumpEventQueue();
  }

  test('stacks captures from several devices, newest in front', () async {
    await capture('a');
    await capture('b');
    await capture('c');

    expect(
      bloc.state.captures.map((capture) => capture.modelName),
      ['Model c', 'Model b', 'Model a'],
    );
    expect(bloc.state.topmost?.modelName, 'Model c');
  });

  test('hands a pressed capture to the system', () async {
    await capture('a');

    await press(bloc.state.topmost!);

    expect(repository.handedToTheSystem.single.modelName, 'Model a');
  });

  test('takes a capture out of the corner once it was opened', () async {
    await capture('a');
    await capture('b');

    await press(bloc.state.topmost!);

    expect(bloc.state.captures.map((c) => c.modelName), ['Model a']);
  });

  test('keeps the rest of the stack when one is dismissed', () async {
    await capture('a');
    await capture('b');
    await capture('c');

    bloc.add(.onPreviewDismissed(bloc.state.topmost!));
    await pumpEventQueue();

    expect(bloc.state.captures.map((c) => c.modelName), ['Model b', 'Model a']);
  });

  test('drops the oldest capture once the pile is full', () async {
    for (var index = 0; index <= maxStackedCaptures; index += 1) {
      await capture('$index');
    }

    expect(bloc.state.captures, hasLength(maxStackedCaptures));
    expect(bloc.state.captures.last.modelName, 'Model 1');
  });

  test('does not let a device pile up twice for the same file', () async {
    await capture('a');
    await capture('a');

    expect(bloc.state.captures, hasLength(1));
  });
}
