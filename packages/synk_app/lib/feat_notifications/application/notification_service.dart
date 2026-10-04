import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  final _notifications = PublishSubject<AppNotification>();

  void notify(AppNotification notification) {
    _notifications.add(notification);
  }

  Stream<AppNotification> observeNotifications() {
    return _notifications.stream;
  }

  Future<void> dispose() {
    return _notifications.close();
  }
}
