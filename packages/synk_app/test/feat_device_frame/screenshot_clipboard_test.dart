import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_frame/application/file_picker.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository_impl.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_event.dart';

import '../support/fake_device_session.dart';
import '../support/fake_host_clipboard.dart';
import '../support/fake_settings_repository.dart';

final _png = Uint8List.fromList([1, 2, 3, 4]);

void main() {
  late Directory directory;
  late FakeHostClipboard clipboard;
  late FakeSettingsRepository settings;
  late ScreenCaptureEventChannel channel;
  late List<ScreenCaptureEvent> announced;
  late DeviceFrameRepositoryImpl repository;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('synk_clipboard_test');
    clipboard = FakeHostClipboard();
    settings = FakeSettingsRepository(
      screenCaptureSavePath: directory.path,
    );
    channel = ScreenCaptureEventChannel();
    announced = [];
    channel.observeEvents().listen(announced.add);

    repository = DeviceFrameRepositoryImpl(
      deviceId: const DeviceId('serial-1'),
      modelName: 'Test Device',
      session: FakeDeviceSession(screenCapture: _FakeScreenCapture()),
      settingsRepository: settings,
      screenCaptureEventChannel: channel,
      hostClipboard: clipboard,
      filePicker: const SystemFilePicker(),
    );
  });

  tearDown(() async {
    await channel.dispose();
    directory.deleteSync(recursive: true);
  });

  group('DeviceFrameRepository.captureScreenshot', () {
    test('copies the screenshot when the preference asks for it', () async {
      settings.update((it) => it.copyWith(copyScreenshotToClipboard: true));

      await repository.captureScreenshot();

      expect(clipboard.images, hasLength(1));
      expect(clipboard.images.single, _png);
    });

    test('leaves the clipboard alone when it does not', () async {
      settings.update((it) => it.copyWith(copyScreenshotToClipboard: false));

      await repository.captureScreenshot();

      expect(clipboard.images, isEmpty);
    });

    test('writes the file either way', () async {
      settings.update((it) => it.copyWith(copyScreenshotToClipboard: true));

      await repository.captureScreenshot();
      await pumpEventQueue();

      expect(announced, hasLength(1));
      expect(File(announced.single.filepath).existsSync(), isTrue);
    });

    test('survives a clipboard that refuses the image', () async {
      settings.update((it) => it.copyWith(copyScreenshotToClipboard: true));
      clipboard.fails = true;

      // The file is already saved by then — a pasteboard problem must not be
      // reported to the user as a failed screenshot.
      await expectLater(repository.captureScreenshot(), completes);
      await pumpEventQueue();

      expect(announced, hasLength(1));
      expect(File(announced.single.filepath).existsSync(), isTrue);
    });
  });
}

class _FakeScreenCapture implements DeviceScreenCapture {
  @override
  Future<Uint8List> captureScreenshot() async => _png;

  @override
  Future<void> startRecording(String path, {required bool withAudio}) async {}

  @override
  Future<bool> stopRecording() async => true;
}
