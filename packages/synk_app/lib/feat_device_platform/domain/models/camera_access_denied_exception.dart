import 'package:synk/user_facing_exception.dart';

class const CameraAccessDeniedException() implements UserFacingException {
  @override
  String toString() =>
      'Kein Kamerazugriff. Bitte in den Systemeinstellungen unter '
      'Datenschutz & Sicherheit › Kamera erlauben.';
}
