import 'package:synk/user_facing_exception.dart';

/// The text to put in front of the user for [error].
///
/// A [UserFacingException] already says what happened and what to do, so it
/// speaks for itself. Anything else is a developer-facing error: the user gets
/// [fallback], and the raw error stays in the log, where the interactor's
/// logger already put it.
String userMessageFor(Object error, String fallback) {
  return error is UserFacingException ? '$error' : fallback;
}
