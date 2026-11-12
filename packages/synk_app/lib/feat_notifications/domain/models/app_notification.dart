import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';

enum NotificationSeverity {
  info,
  success,
  warning,
  error,
}

typedef NotificationAction = ({String label, void Function() onPressed});

@freezed
sealed class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String message,
    @Default(NotificationSeverity.error) NotificationSeverity severity,
    NotificationAction? action,
  }) = _AppNotification;
}
