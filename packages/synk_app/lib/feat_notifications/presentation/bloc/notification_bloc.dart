import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_bloc.freezed.dart';
part 'notification_state.dart';
part 'notification_event.dart';

class NotificationBloc(
  final NotificationService notifications,
) extends Bloc<NotificationEvent, NotificationState> {
  this : super(NotificationState.initial()) {
    on<_OnSetup>((event, emit) {
      return emit.forEach(
        notifications.observeNotifications(),
        onData: (notification) {
          return state.copyWith(
            sequence: state.sequence + 1,
            notification: notification,
          );
        },
      );
    }, transformer: droppable());

    add(const NotificationEvent.onSetup());
  }
}
