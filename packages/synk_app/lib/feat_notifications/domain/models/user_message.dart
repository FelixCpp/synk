import 'package:synk/user_facing_exception.dart';

String userMessageFor(Object error, String fallback) {
  return error is UserFacingException ? '$error' : fallback;
}
