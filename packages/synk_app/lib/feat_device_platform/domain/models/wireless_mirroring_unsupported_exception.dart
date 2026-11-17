import 'package:synk/user_facing_exception.dart';

class const WirelessMirroringUnsupportedException()
    implements UserFacingException {
  @override
  String toString() =>
      'Kabelloses Spiegeln wird für dieses Gerät noch nicht unterstützt. '
      'Bitte per USB-Kabel verbinden.';
}
