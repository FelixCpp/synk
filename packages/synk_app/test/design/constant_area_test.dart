import 'package:flutter_test/flutter_test.dart';
import 'package:synk/design/constant_area.dart';

void main() {
  group('sizeForConstantArea', () {
    const area = 320.0 * (320.0 / (9 / 20));

    test('holds the area it was given, whatever the shape', () {
      const aspectRatios = [9 / 20, 20 / 9, 2560 / 1600, 1600 / 2560, 1.0];

      for (final aspectRatio in aspectRatios) {
        final size = sizeForConstantArea(area, aspectRatio);

        expect(
          size.width * size.height,
          closeTo(area, 1.0),
          reason: '$aspectRatio does not get its fair share',
        );
      }
    });

    test('keeps the shape it was asked for', () {
      final size = sizeForConstantArea(area, 9 / 20);

      expect(size.width / size.height, closeTo(9 / 20, 0.0001));
    });

    test('only trades width and height when a device turns', () {
      final portrait = sizeForConstantArea(area, 1080 / 2400);
      final landscape = sizeForConstantArea(area, 2400 / 1080);

      expect(landscape.width, closeTo(portrait.height, 0.01));
      expect(landscape.height, closeTo(portrait.width, 0.01));
    });
  });
}
