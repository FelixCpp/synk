import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification.freezed.dart';

enum NotificationSeverity { error, critical }

@freezed
sealed class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String message,
    @Default(NotificationSeverity.error) NotificationSeverity severity,
  }) = _AppNotification;
}
