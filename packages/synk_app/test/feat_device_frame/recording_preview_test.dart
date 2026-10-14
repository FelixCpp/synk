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

final _poster = Uint8List.fromList([1, 2, 3]);

void main() {
  late Directory directory;
  late _FakeScreenCapture screenCapture;
  late FakeSettingsRepository settings;
  late ScreenCaptureEventChannel channel;
  late List<ScreenCaptureEvent> announced;
  late DeviceFrameRepositoryImpl repository;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('synk_recording_test');
    screenCapture = _FakeScreenCapture();
    channel = ScreenCaptureEventChannel();
    announced = [];
    channel.observeEvents().listen(announced.add);

    settings = FakeSettingsRepository(
      screenCaptureSavePath: directory.path,
    );
    repository = DeviceFrameRepositoryImpl(
      deviceId: const DeviceId('serial-1'),
      modelName: 'Test Device',
      session: FakeDeviceSession(screenCapture: screenCapture),
      settingsRepository: settings,
      screenCaptureEventChannel: channel,
      hostClipboard: FakeHostClipboard(),
      filePicker: const SystemFilePicker(),
    );
  });

  tearDown(() async {
    await channel.dispose();
    directory.deleteSync(recursive: true);
  });

  group('DeviceFrameRepository recording previews', () {
    test('announces the finished recording with a poster frame', () async {
      await repository.startRecording();
      await repository.stopRecording();
      await pumpEventQueue();

      expect(announced, hasLength(1));
      expect(announced.single.filepath, screenCapture.startedPath);
      expect(announced.single.filepath, endsWith('.mp4'));

      announced.single.map(
        png: (_) => fail('a recording must not pose as a screenshot'),
        video: (video) {
          expect(video.posterBytes, _poster);
          expect(video.modelName, 'Test Device');
        },
      );
    });

    test('announces one whose poster could not be taken', () async {
      screenCapture.screenshotFails = true;

      await repository.startRecording();
      await repository.stopRecording();
      await pumpEventQueue();

      announced.single.map(
        png: (_) => fail('a recording must not pose as a screenshot'),
        video: (video) => expect(video.posterBytes, isNull),
      );
    });

    test('stays quiet when the recorder wrote no frames', () async {
      screenCapture.stopResult = false;

      await repository.startRecording();
      await expectLater(repository.stopRecording(), throwsA(isA<Exception>()));
      await pumpEventQueue();

      expect(announced, isEmpty);
    });

    test('asks for sound when the preference says so', () async {
      settings.update((it) => it.copyWith(recordAudio: true));

      await repository.startRecording();

      expect(screenCapture.startedWithAudio, isTrue);
    });

    test('asks for a silent recording when it does not', () async {
      settings.update((it) => it.copyWith(recordAudio: false));

      await repository.startRecording();

      expect(screenCapture.startedWithAudio, isFalse);
    });

    test('announces a recording only once', () async {
      await repository.startRecording();
      await repository.stopRecording();
      await repository.stopRecording();
      await pumpEventQueue();

      expect(announced, hasLength(1));
    });

    test('stays quiet for a stop without a start', () async {
      await repository.stopRecording();
      await pumpEventQueue();

      expect(announced, isEmpty);
    });
  });
}

class _FakeScreenCapture implements DeviceScreenCapture {
  String? startedPath;
  bool? startedWithAudio;
  bool stopResult = true;
  bool screenshotFails = false;

  @override
  Future<Uint8List> captureScreenshot() async {
    if (screenshotFails) {
      throw Exception('the device agent is not answering');
    }

    return _poster;
  }

  @override
  Future<void> startRecording(String path, {required bool withAudio}) async {
    startedPath = path;
    startedWithAudio = withAudio;
  }

  @override
  Future<bool> stopRecording() async => stopResult;
}
