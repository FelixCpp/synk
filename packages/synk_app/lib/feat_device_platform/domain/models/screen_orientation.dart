import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';

enum DeviceRotationDirection {
  left,
  right,
}

enum ScreenOrientation {
  portrait,
  landscapeLeft,
  portraitUpsideDown,
  landscapeRight;

  factory ScreenOrientation.guessedFrom(DeviceScreenSize screenSize) {
    return screenSize.width > screenSize.height ? landscapeLeft : portrait;
  }

  ScreenOrientation turned(DeviceRotationDirection direction) {
    final quarterTurns = switch (direction) {
      .left => 1,
      .right => -1,
    };

    return values[(index + quarterTurns) % values.length];
  }
}
