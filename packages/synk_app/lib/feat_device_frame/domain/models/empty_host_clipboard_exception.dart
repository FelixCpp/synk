import 'package:synk/user_facing_exception.dart';

class const EmptyHostClipboardException() implements UserFacingException {
  @override
  String toString() => 'Die Zwischenablage enthält keinen Text.';
}
