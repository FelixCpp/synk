import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_frame/domain/device_frame_interactors.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_event.dart';

import '../support/device_frame_harness.dart';

final _poster = Uint8List.fromList([1, 2, 3]);
final _takenAt = DateTime(2026, 10, 15, 9, 41, 7);

void main() {
  late DeviceFrameHarness harness;
  late _FakeScreenCapture screenCapture;
  late DeviceFrameInteractors device;

  setUp(() {
    screenCapture = _FakeScreenCapture();
    harness = DeviceFrameHarness(
      screenCapture: screenCapture,
      takenAt: _takenAt,
    );
    addTearDown(harness.dispose);
    device = harness.device;
  });

  group('DeviceFrameRepository recording previews', () {
    test('announces the finished recording with a poster frame', () async {
      await device.startRecording.getOrThrow(unit);
      await device.stopRecording.getOrThrow(unit);
      await pumpEventQueue();

      expect(harness.announced, hasLength(1));
      expect(harness.announced.single.filepath, screenCapture.startedPath);
      expect(
        harness.announced.single.filepath,
        '/captures/Recording Test Device 2026-10-15 at 09.41.07.mp4',
      );

      harness.announced.single.map(
        png: (_) => fail('a recording must not pose as a screenshot'),
        video: (video) {
          expect(video.posterBytes, _poster);
          expect(video.modelName, 'Test Device');
        },
      );
    });

    test('announces one whose poster could not be taken', () async {
      screenCapture.screenshotFails = true;

      await device.startRecording.getOrThrow(unit);
      await device.stopRecording.getOrThrow(unit);
      await pumpEventQueue();

      harness.announced.single.map(
        png: (_) => fail('a recording must not pose as a screenshot'),
        video: (video) => expect(video.posterBytes, isNull),
      );
    });

    test('stays quiet when the recorder wrote no frames', () async {
      screenCapture.stopResult = false;

      await device.startRecording.getOrThrow(unit);
      await expectLater(device.stopRecording.getOrThrow(unit), throwsA(isA<Exception>()));
      await pumpEventQueue();

      expect(harness.announced, isEmpty);
    });

    test('asks for sound when the preference says so', () async {
      harness.settings.update((it) => it.copyWith(recordAudio: true));

      await device.startRecording.getOrThrow(unit);

      expect(screenCapture.startedWithAudio, isTrue);
    });

    test('asks for a silent recording when it does not', () async {
      harness.settings.update((it) => it.copyWith(recordAudio: false));

      await device.startRecording.getOrThrow(unit);

      expect(screenCapture.startedWithAudio, isFalse);
    });

    test('announces a recording only once', () async {
      await device.startRecording.getOrThrow(unit);
      await device.stopRecording.getOrThrow(unit);
      await device.stopRecording.getOrThrow(unit);
      await pumpEventQueue();

      expect(harness.announced, hasLength(1));
    });

    test('stays quiet for a stop without a start', () async {
      await device.stopRecording.getOrThrow(unit);
      await pumpEventQueue();

      expect(harness.announced, isEmpty);
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
