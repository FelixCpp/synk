import 'dart:math' as math;

import 'package:synk/feat_notifications/domain/models/notification_entry.dart';
import 'package:synk/feat_notifications/domain/notification_policy.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_stack.freezed.dart';

@freezed
sealed class NotificationStack with _$NotificationStack {
  const NotificationStack._();

  const factory NotificationStack({
    required List<NotificationEntry> entries,
  }) = _NotificationStack;

  static const empty = NotificationStack(entries: []);

  /// The entries the stack has room for, oldest first, newest last.
  List<NotificationEntry> get visible {
    return entries.length <= NotificationPolicy.maxVisible
        ? entries
        : entries.sublist(entries.length - NotificationPolicy.maxVisible);
  }

  int get hiddenCount {
    return math.max(0, entries.length - NotificationPolicy.maxVisible);
  }
}
