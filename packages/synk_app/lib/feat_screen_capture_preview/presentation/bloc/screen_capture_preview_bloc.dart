import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_notifications/domain/models/user_message.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_event.dart';
import 'package:synk/feat_screen_capture_preview/domain/screen_capture_preview_feature.dart';
import 'package:synk/feat_screen_capture_preview/domain/usecases/open_in_system_viewer_interactor.dart';
import 'package:use_in_case/use_in_case.dart';

part 'screen_capture_preview_bloc.freezed.dart';
part 'screen_capture_preview_event.dart';
part 'screen_capture_preview_state.dart';

const maxStackedCaptures = 4;

class ScreenCapturePreviewBloc(
  final ScreenCapturePreviewFeature feature,
  final NotificationService notifications,
) extends Bloc<ScreenCapturePreviewEvent, ScreenCapturePreviewState> {
  final openInSystemViewer = OpenInSystemViewerInteractor(feature);

  this : super(ScreenCapturePreviewState.initial()) {
    on<_OnSetup>(_onSetup);
    on<_OnPreviewPressed>(_onPreviewPressed, transformer: sequential());
    on<_OnPreviewDismissed>(_onPreviewDismissed);
    add(const .onSetup());
  }

  FutureOr<void> _onSetup(
    _OnSetup event,
    Emitter<ScreenCapturePreviewState> emit,
  ) {
    return emit.forEach(
      feature.observeCaptures(),
      onData: (capture) {
        return state.copyWith(
          captures: [
            capture,
            ..._without(capture),
          ].take(maxStackedCaptures).toList(),
        );
      },
    );
  }

  FutureOr<void> _onPreviewPressed(
    _OnPreviewPressed event,
    Emitter<ScreenCapturePreviewState> emit,
  ) {
    emit(state.copyWith(captures: _without(event.capture)));

    return openInSystemViewer
        .logger()
        .intercept(
          (error) => notifications.notify(
            .new(
              message: userMessageFor(
                error,
                'Die Aufnahme ließ sich nicht öffnen.',
              ),
            ),
          ),
        )
        .run(event.capture);
  }

  FutureOr<void> _onPreviewDismissed(
    _OnPreviewDismissed event,
    Emitter<ScreenCapturePreviewState> emit,
  ) {
    emit(state.copyWith(captures: _without(event.capture)));
  }

  List<ScreenCaptureEvent> _without(ScreenCaptureEvent capture) {
    return state.captures
        .where((other) => other.filepath != capture.filepath)
        .toList();
  }
}
