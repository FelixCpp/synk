import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_notifications/domain/models/user_message.dart';
import 'package:synk/feat_notifications/domain/notification_feature.dart';
import 'package:use_in_case/use_in_case.dart';

extension NotifiedInteractor<Input, Output>
    on ParameterizedResultInteractor<Input, Output> {
  /// Runs the interactor, tells the user when it fails, and calls [andUndo]
  /// first so an optimistic state can step back.
  Future<void> runReporting(
    Input input, {
    required NotificationFeature to,
    required String whenItFails,
    void Function()? andUndo,
  }) {
    return intercept((error) {
      andUndo?.call();
      to.notify(
        AppNotification(message: userMessageFor(error, whenItFails)),
      );
    }).run(input);
  }
}
