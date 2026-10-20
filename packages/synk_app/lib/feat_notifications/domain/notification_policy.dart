import 'package:synk/feat_notifications/domain/models/app_notification.dart';

/// How long a message stays, and how many of them the stack shows at once.
class NotificationPolicy {
  const NotificationPolicy._();

  static const int maxVisible = 4;
  static const Duration tick = Duration(milliseconds: 100);

  static Duration? lifetimeOf(NotificationSeverity severity) {
    return switch (severity) {
      .success => const Duration(seconds: 4),
      .warning || .error => null,
    };
  }
}
