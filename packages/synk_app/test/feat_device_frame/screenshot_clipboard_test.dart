import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_frame/domain/device_frame_interactors.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';

import '../support/device_frame_harness.dart';

final _png = Uint8List.fromList([1, 2, 3, 4]);
final _takenAt = DateTime(2026, 10, 15, 9, 41, 7);

void main() {
  late DeviceFrameHarness harness;
  late DeviceFrameInteractors device;

  setUp(() {
    harness = DeviceFrameHarness(
      screenCapture: _FakeScreenCapture(),
      takenAt: _takenAt,
    );
    addTearDown(harness.dispose);
    device = harness.device;
  });

  group('DeviceFrameRepository.captureScreenshot', () {
    test('copies the screenshot when the preference asks for it', () async {
      harness.settings.update(
        (it) => it.copyWith(copyScreenshotToClipboard: true),
      );

      await device.captureScreenshot.getOrThrow(unit);

      expect(harness.host.images, hasLength(1));
      expect(harness.host.images.single, _png);
    });

    test('leaves the clipboard alone when it does not', () async {
      harness.settings.update(
        (it) => it.copyWith(copyScreenshotToClipboard: false),
      );

      await device.captureScreenshot.getOrThrow(unit);

      expect(harness.host.images, isEmpty);
    });

    test('writes the file either way', () async {
      harness.settings.update(
        (it) => it.copyWith(copyScreenshotToClipboard: true),
      );

      await device.captureScreenshot.getOrThrow(unit);
      await pumpEventQueue();

      expect(harness.announced, hasLength(1));
      expect(
        harness.fileSystem.file(harness.announced.single.filepath).existsSync(),
        isTrue,
      );
    });

    test('names the file after the device and when it was taken', () async {
      await device.captureScreenshot.getOrThrow(unit);
      await pumpEventQueue();

      expect(
        harness.announced.single.filepath,
        '/captures/Screenshot Test Device 2026-10-15 at 09.41.07.png',
      );
    });

    test('survives a clipboard that refuses the image', () async {
      harness.settings.update(
        (it) => it.copyWith(copyScreenshotToClipboard: true),
      );
      harness.host.fails = true;

      // The file is already saved by then — a pasteboard problem must not be
      // reported to the user as a failed screenshot.
      await expectLater(device.captureScreenshot.getOrThrow(unit), completes);
      await pumpEventQueue();

      expect(harness.announced, hasLength(1));
      expect(
        harness.fileSystem.file(harness.announced.single.filepath).existsSync(),
        isTrue,
      );
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
