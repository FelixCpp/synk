import 'package:synk/user_facing_exception.dart';

class const WirelessConnectException({
  required final String detail,
}) implements UserFacingException {
  @override
  String toString() => 'Die Verbindung ist fehlgeschlagen: $detail';
}
