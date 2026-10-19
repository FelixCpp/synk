/// An exception whose [toString] is written for the person using Synk, in
/// German, and says what to do about it.
///
/// Only these reach the user as they are. Everything else gets a message the
/// caller chose, while the raw error goes to the log — so a stray
/// `Exception('wm size')` can never end up in a dialog.
abstract interface class UserFacingException implements Exception {}
