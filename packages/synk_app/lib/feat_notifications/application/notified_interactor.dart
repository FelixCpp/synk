import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_notifications/domain/models/user_message.dart';
import 'package:use_in_case/use_in_case.dart';

extension NotifiedInteractor<Input, Output>
    on ParameterizedResultInteractor<Input, Output> {
  /// Runs the interactor and tells the user when it fails.
  ///
  /// Prefer this over [run]: that one swallows every exception without a
  /// trace, so a forgotten `intercept` turns a failure into nothing happening
  /// at all. Here the report is part of running it.
  ///
  /// [whenItFails] is shown for a developer-facing error; an exception written
  /// for the user speaks for itself. Either way the raw error stays in the log.
  ///
  /// Chain this last. Anything intercepting ahead of it has to pass
  /// `consume: false`, or the exception arrives here wrapped in a
  /// `HandledException` and the user is told nothing at all — `consume`
  /// defaults to `true`.
  Future<void> runReporting(
    Input input, {
    required NotificationService to,
    required String whenItFails,
  }) {
    return intercept(
      (error) => to.notify(
        AppNotification(message: userMessageFor(error, whenItFails)),
      ),
    ).run(input);
  }
}
