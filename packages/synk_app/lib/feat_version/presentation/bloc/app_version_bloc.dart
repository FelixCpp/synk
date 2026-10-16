import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_version/domain/models/app_version.dart';
import 'package:synk/feat_version/domain/models/newer_app_version.dart';
import 'package:synk/feat_version/domain/repositories/app_version_repository.dart';
import 'package:synk/feat_version/domain/usecases/get_newer_app_version_interactor.dart';
import 'package:synk/feat_version/domain/usecases/update_to_newest_version_interactor.dart';
import 'package:use_in_case/use_in_case.dart';

part 'app_version_bloc.freezed.dart';
part 'app_version_state.dart';
part 'app_version_event.dart';

class AppVersionBloc(
  AppVersion currentAppVersion,
  final AppVersionRepository repository,
  final NotificationService notifications,
) extends Bloc<AppVersionEvent, AppVersionState> {
  final getNewerAppVersion = GetNewerAppVersionInteractor(repository);

  this : super(AppVersionState.initial(currentAppVersion)) {
    on<_OnCheckForUpdates>(_onCheckForUpdates, transformer: droppable());
    on<_OnUpdate>(_onUpdate, transformer: droppable());

    add(const .onCheckForUpdates());
  }

  FutureOr<void> _onCheckForUpdates(
    _OnCheckForUpdates event,
    Emitter<AppVersionState> emit,
  ) async {
    emit(state.copyWith(newerAppVersion: null));

    final newerAppVersion = await getNewerAppVersion
        .logger()
        .ensureMinExecutionTimeOnSuccess(const .new(milliseconds: 500))
        .getOrElse(
          unit,
          (_) => const NewerAppVersion.failedToFetch(),
        );

    emit(state.copyWith(newerAppVersion: newerAppVersion));
  }

  FutureOr<void> _onUpdate(_OnUpdate event, Emitter<AppVersionState> emit) {
    return UpdateToNewestAppVersionInteractor(repository)
        .receiveProgress((progress) {
          if (!emit.isDone) {
            emit(state.copyWith(downloadProgress: progress));
          }
        })
        .logger(tag: 'UpdateToNewestAppVersionInteractor')
        .busyStateChange((isBusy) {
          emit(state.copyWith(isUpdating: isBusy, downloadProgress: null));
        })
        .intercept((e) {
          notifications.notify(.new(message: 'Update fehlgeschlagen: $e'));
        })
        .run(unit);
  }
}
