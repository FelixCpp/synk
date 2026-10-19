import 'package:synk/user_facing_exception.dart';

class const DeviceClipboardUnavailableException()
    implements UserFacingException {
  @override
  String toString() =>
      'Die Zwischenablage braucht Xcode (devicectl), das sich nicht ausführen '
      'lässt. Bitte Xcode installieren und die Lizenz akzeptieren.';
}

class const DeviceClipboardUnreachableException()
    implements UserFacingException {
  @override
  String toString() =>
      'Die Zwischenablage des Geräts ist nicht erreichbar. Gerät entsperren '
      'und erneut versuchen.';
}
