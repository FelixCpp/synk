import 'package:synk/design/theme/synk_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('screenCapturePreviewSizeFor', () {
    test('keeps the reference device on the established thumbnail size', () {
      const referenceAspectRatio = SynkTheme.screenCapturePreviewReferenceAspectRatio;

      final size = SynkTheme.screenCapturePreviewSizeFor(referenceAspectRatio);

      expect(size.width, closeTo(SynkTheme.screenCapturePreviewWidth, 0.01));
      expect(
        size.height,
        closeTo(SynkTheme.screenCapturePreviewWidth / referenceAspectRatio, 0.01),
      );
    });

    test('turns the thumbnail sideways when the device is', () {
      final portrait = SynkTheme.screenCapturePreviewSizeFor(1080 / 2400);
      final landscape = SynkTheme.screenCapturePreviewSizeFor(2400 / 1080);

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
        final size = SynkTheme.screenCapturePreviewSizeFor(aspectRatio);

        expect(
          size.width * size.height,
          closeTo(SynkTheme.screenCapturePreviewArea, 1.0),
          reason: '$aspectRatio does not get its fair share of the corner',
        );
      }
    });
  });
}
