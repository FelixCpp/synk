import 'package:flutter/widgets.dart';
import 'package:synk/design/theme/synk_theme.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_frame/presentation/device_frame.dart';
import 'package:flutter_test/flutter_test.dart';

double _mirrorArea(Size tile) {
  return tile.width * (tile.height - SynkTheme.deviceFrameChromeHeight);
}

void main() {
  group('deviceFrameSizeFor', () {
    test('keeps the reference device on the established tile size', () {
      const portrait = DeviceScreenSize(width: 1080, height: 2400);

      final tile = deviceFrameSizeFor(portrait);

      expect(tile.width, closeTo(SynkTheme.deviceFrameWidth, 0.01));
      expect(tile.height, closeTo(SynkTheme.deviceFrameHeight, 0.01));
    });

    test('turns the tile sideways when the device is', () {
      const portrait = DeviceScreenSize(width: 1080, height: 2400);
      const landscape = DeviceScreenSize(width: 2400, height: 1080);

      final portraitTile = deviceFrameSizeFor(portrait);
      final landscapeTile = deviceFrameSizeFor(landscape);

      expect(landscapeTile.width, greaterThan(landscapeTile.height));
      expect(
        landscapeTile.width,
        closeTo(portraitTile.height - SynkTheme.deviceFrameChromeHeight, 0.01),
      );
      expect(
        landscapeTile.height - SynkTheme.deviceFrameChromeHeight,
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
          _mirrorArea(deviceFrameSizeFor(size)),
          closeTo(SynkTheme.deviceFrameMirrorArea, 1.0),
          reason: '$size does not get its fair share of canvas',
        );
      }
    });
  });
}
