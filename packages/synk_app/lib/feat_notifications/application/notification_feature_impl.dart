import 'dart:async';

import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_notifications/domain/models/notification_entry.dart';
import 'package:synk/feat_notifications/domain/models/notification_stack.dart';
import 'package:synk/feat_notifications/domain/notification_feature.dart';
import 'package:synk/feat_notifications/domain/notification_policy.dart';
import 'package:rxdart/rxdart.dart';

class NotificationFeatureImpl({
  final Duration tick = NotificationPolicy.tick,
}) implements NotificationFeature {
  final _reported = PublishSubject<AppNotification>();
  final _stack = BehaviorSubject<NotificationStack>.seeded(
    NotificationStack.empty,
  );

  var _nextId = 1;
  var _isPaused = false;
  Timer? _countdown;

  @override
  Stream<AppNotification> observeNotifications() => _reported.stream;

  @override
  Stream<NotificationStack> observeStack() => _stack.stream;

  @override
  void notify(AppNotification notification) {
    _reported.add(notification);

    final entries = [..._stack.value.entries];
    final lifetime = NotificationPolicy.lifetimeOf(notification.severity);
    final repeated = entries.indexWhere(
      (entry) => entry.notification == notification,
    );

    if (repeated < 0) {
      entries.add(
        NotificationEntry(
          id: _nextId++,
          notification: notification,
          lifetime: lifetime,
          remaining: lifetime,
        ),
      );
    } else {
      final entry = entries[repeated];
      entries[repeated] = NotificationEntry(
        id: entry.id,
        notification: entry.notification,
        count: entry.count + 1,
        lifetime: lifetime,
        remaining: lifetime,
      );
    }

    _emit(entries);
  }

  @override
  void dismiss(int id) {
    _emit(_stack.value.entries.where((entry) => entry.id != id).toList());
  }

  @override
  void dismissAll() => _emit(const []);

  @override
  void setPaused(bool isPaused) {
    if (_isPaused == isPaused) {
      return;
    }

    _isPaused = isPaused;
    _syncCountdown();
  }

  @override
  Future<void> dispose() {
    _countdown?.cancel();
    _countdown = null;
    return Future.wait([_reported.close(), _stack.close()]);
  }

  void _emit(List<NotificationEntry> entries) {
    _stack.add(NotificationStack(entries: entries));
    _syncCountdown();
  }

  void _syncCountdown() {
    final isCounting = _stack.value.entries.any(
      (entry) => entry.remaining != null,
    );

    if (!_isPaused && isCounting) {
      _countdown ??= Timer.periodic(tick, (_) => _onTick());
      return;
    }

    _countdown?.cancel();
    _countdown = null;
  }

  void _onTick() {
    final survivors = <NotificationEntry>[];
    var isCounting = false;

    for (final entry in _stack.value.entries) {
      final remaining = entry.remaining;

      if (remaining == null) {
        survivors.add(entry);
        continue;
      }

      isCounting = true;
      final left = remaining - tick;

      if (left > Duration.zero) {
        survivors.add(entry.copyWith(remaining: left));
      }
    }

    if (!isCounting) {
      _syncCountdown();
      return;
    }

    _emit(survivors);
  }
}
