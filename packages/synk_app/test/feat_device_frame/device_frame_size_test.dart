import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_frame/presentation/device_frame_metrics.dart';

void main() {
  group('DeviceFrameMetrics.sizeFor', () {
    test('puts the reference device on the established tile size', () {
      final tile = DeviceFrameMetrics.sizeFor(
        DeviceFrameMetrics.referenceAspectRatio,
      );

      expect(tile.width, closeTo(DeviceFrameMetrics.referenceWidth, 0.01));
      expect(tile.height, closeTo(DeviceFrameMetrics.height, 0.01));
    });

    test('adds the chrome on top of a constant mirror area', () {
      for (final aspectRatio in [9 / 20, 20 / 9, 2560 / 1600]) {
        final tile = DeviceFrameMetrics.sizeFor(aspectRatio);
        final mirrorHeight = tile.height - DeviceFrameMetrics.chromeHeight;

        expect(
          tile.width * mirrorHeight,
          closeTo(DeviceFrameMetrics.mirrorArea, 1.0),
          reason: 'the chrome must not eat into the mirror at $aspectRatio',
        );
      }
    });
  });
}
