import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_notifications/domain/models/notification_stack.dart';

/// What Synk can do with the pile of messages in the canvas corner.
abstract interface class NotificationFeature {
  void notify(AppNotification notification);

  /// Every message as it is reported, whether or not it reaches the stack.
  Stream<AppNotification> observeNotifications();

  /// The pile as it stands, with repeats counted and the overflow folded away.
  Stream<NotificationStack> observeStack();
  void dismiss(int id);
  void dismissAll();

  /// Stops and resumes the countdown of everything on the stack, so a message
  /// cannot leave while it is being read.
  void setPaused(bool isPaused);

  Future<void> dispose();
}
