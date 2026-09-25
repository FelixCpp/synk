part of 'notification_bloc.dart';

@freezed
sealed class NotificationState with _$NotificationState {
  const factory NotificationState({
    required int sequence,
    AppNotification? notification,
  }) = _NotificationState;

  factory NotificationState.initial() {
    return const NotificationState(sequence: 0);
  }
}
