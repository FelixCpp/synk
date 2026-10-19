import 'package:flutter/widgets.dart';
import 'package:synk/feat_device_frame/presentation/device_frame_metrics.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:flutter_test/flutter_test.dart';

double _mirrorArea(Size tile) {
  return tile.width * (tile.height - DeviceFrameMetrics.chromeHeight);
}

void main() {
  group('DeviceFrameMetrics.sizeFor', () {
    test('keeps the reference device on the established tile size', () {
      const portrait = DeviceScreenSize(width: 1080, height: 2400);

      final tile = DeviceFrameMetrics.sizeFor(portrait.aspectRatio);

      expect(tile.width, closeTo(DeviceFrameMetrics.referenceWidth, 0.01));
      expect(tile.height, closeTo(DeviceFrameMetrics.height, 0.01));
    });

    test('turns the tile sideways when the device is', () {
      const portrait = DeviceScreenSize(width: 1080, height: 2400);
      const landscape = DeviceScreenSize(width: 2400, height: 1080);

      final portraitTile = DeviceFrameMetrics.sizeFor(portrait.aspectRatio);
      final landscapeTile = DeviceFrameMetrics.sizeFor(landscape.aspectRatio);

      expect(landscapeTile.width, greaterThan(landscapeTile.height));
      expect(
        landscapeTile.width,
        closeTo(portraitTile.height - DeviceFrameMetrics.chromeHeight, 0.01),
      );
      expect(
        landscapeTile.height - DeviceFrameMetrics.chromeHeight,
        closeTo(portraitTile.width, 0.01),
      );
    });

    test('spends the same screen area whatever the orientation', () {
      const sizes = [
        DeviceScreenSize(width: 1080, height: 2400),
        DeviceScreenSize(width: 2400, height: 1080),
        DeviceScreenSize(width: 2560, height: 1600),
        DeviceScreenSize(width: 1600, height: 2560),
      ];

      for (final size in sizes) {
        expect(
          _mirrorArea(DeviceFrameMetrics.sizeFor(size.aspectRatio)),
          closeTo(DeviceFrameMetrics.mirrorArea, 1.0),
          reason: '$size does not get its fair share of canvas',
        );
      }
    });
  });
}
