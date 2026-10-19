import 'package:synk/user_facing_exception.dart';

/// Pairing was refused. [detail] is what adb printed, which is the only thing
/// that says why — a wrong code reads differently from an unreachable host.
class const DevicePairingException({
  required final String detail,
}) implements UserFacingException {
  @override
  String toString() => 'Die Kopplung ist fehlgeschlagen: $detail';
}
