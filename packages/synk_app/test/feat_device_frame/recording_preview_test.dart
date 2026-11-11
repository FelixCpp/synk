import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_frame/domain/device_frame_interactors.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_event.dart';
import 'package:use_in_case/use_in_case.dart';

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
      await device.startRecording.getOrThrow();
      await device.stopRecording.getOrThrow();
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

      await device.startRecording.getOrThrow();
      await device.stopRecording.getOrThrow();
      await pumpEventQueue();

      harness.announced.single.map(
        png: (_) => fail('a recording must not pose as a screenshot'),
        video: (video) => expect(video.posterBytes, isNull),
      );
    });

    test('stays quiet when the recorder wrote no frames', () async {
      screenCapture.stopResult = false;

      await device.startRecording.getOrThrow();
      await expectLater(
        device.stopRecording.getOrThrow(),
        throwsA(isA<Exception>()),
      );
      await pumpEventQueue();

      expect(harness.announced, isEmpty);
    });

    test('asks for sound when the preference says so', () async {
      harness.settings.update((it) => it.copyWith(recordAudio: true));

      await device.startRecording.getOrThrow();

      expect(screenCapture.startedWithAudio, isTrue);
    });

    test('asks for a silent recording when it does not', () async {
      harness.settings.update((it) => it.copyWith(recordAudio: false));

      await device.startRecording.getOrThrow();

      expect(screenCapture.startedWithAudio, isFalse);
    });

    test('announces a recording only once', () async {
      await device.startRecording.getOrThrow();
      await device.stopRecording.getOrThrow();
      await device.stopRecording.getOrThrow();
      await pumpEventQueue();

      expect(harness.announced, hasLength(1));
    });

    test('stays quiet for a stop without a start', () async {
      await device.stopRecording.getOrThrow();
      await pumpEventQueue();

      expect(harness.announced, isEmpty);
    });

    test('knows about a recording that a frame before it started', () {
      final running = _FakeScreenCapture()..recordingPath = '/captures/a.mp4';
      final later = DeviceFrameHarness(screenCapture: running);
      addTearDown(later.dispose);

      expect(later.bloc.state.isRecording, isTrue);
    });

    test('finishes a recording that a frame before it started', () async {
      final running = _FakeScreenCapture()..recordingPath = '/captures/a.mp4';
      final later = DeviceFrameHarness(screenCapture: running);
      addTearDown(later.dispose);

      await later.device.stopRecording.getOrThrow();
      await pumpEventQueue();

      expect(later.announced.single.filepath, '/captures/a.mp4');
    });

    test('lets go of a recording the recorder failed to finish', () async {
      final bloc = harness.bloc;
      screenCapture.stopResult = false;

      bloc.add(const .onToggleRecording());
      await pumpEventQueue();
      expect(bloc.state.isRecording, isTrue);

      bloc.add(const .onToggleRecording());
      await pumpEventQueue();
      expect(bloc.state.isRecording, isFalse);
      expect(harness.shown, ['Die Aufnahme ließ sich nicht beenden.']);

      screenCapture.startedPath = null;
      bloc.add(const .onToggleRecording());
      await pumpEventQueue();
      expect(bloc.state.isRecording, isTrue);
      expect(screenCapture.startedPath, isNotNull);
    });
  });
}

class _FakeScreenCapture implements DeviceScreenCapture {
  String? startedPath;
  bool? startedWithAudio;

  @override
  String? recordingPath;
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
    recordingPath = path;
  }

  @override
  Future<bool> stopRecording() async {
    recordingPath = null;
    return stopResult;
  }
}
