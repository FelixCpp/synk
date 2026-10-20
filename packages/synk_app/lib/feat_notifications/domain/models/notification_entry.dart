import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_entry.freezed.dart';

@freezed
sealed class NotificationEntry with _$NotificationEntry {
  const NotificationEntry._();

  const factory NotificationEntry({
    required int id,
    required AppNotification notification,
    @Default(1) int count,
    Duration? lifetime,
    Duration? remaining,
  }) = _NotificationEntry;

  /// How much of the standing time is left, from 1.0 down to 0.0, or null for
  /// an entry that stays until it is dismissed.
  double? get timeLeft {
    final lifetime = this.lifetime;
    final remaining = this.remaining;

    if (lifetime == null || remaining == null) {
      return null;
    }

    return (remaining.inMicroseconds / lifetime.inMicroseconds).clamp(0.0, 1.0);
  }
}
