import 'package:synk/feat_screen_capture_preview/presentation/screen_capture_preview_metrics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('screenCapturePreviewSizeFor', () {
    test('keeps the reference device on the established thumbnail size', () {
      const referenceAspectRatio =
          ScreenCapturePreviewMetrics.referenceAspectRatio;

      final size = ScreenCapturePreviewMetrics.sizeFor(referenceAspectRatio);

      expect(size.width, closeTo(ScreenCapturePreviewMetrics.referenceWidth, 0.01));
      expect(
        size.height,
        closeTo(
          ScreenCapturePreviewMetrics.referenceWidth / referenceAspectRatio,
          0.01,
        ),
      );
    });

    test('turns the thumbnail sideways when the device is', () {
      final portrait = ScreenCapturePreviewMetrics.sizeFor(1080 / 2400);
      final landscape = ScreenCapturePreviewMetrics.sizeFor(2400 / 1080);

      expect(landscape.width, greaterThan(landscape.height));
      expect(landscape.width, closeTo(portrait.height, 0.01));
      expect(landscape.height, closeTo(portrait.width, 0.01));
    });

    test('spends the same canvas area whatever the orientation', () {
      const aspectRatios = [
        1080 / 2400,
        2400 / 1080,
        2560 / 1600,
        1600 / 2560,
      ];

      for (final aspectRatio in aspectRatios) {
        final size = ScreenCapturePreviewMetrics.sizeFor(aspectRatio);

        expect(
          size.width * size.height,
          closeTo(ScreenCapturePreviewMetrics.area, 1.0),
          reason: '$aspectRatio does not get its fair share of the corner',
        );
      }
    });
  });
}
