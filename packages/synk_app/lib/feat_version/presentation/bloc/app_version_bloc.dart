import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_notifications/domain/notification_feature.dart';
import 'package:synk/feat_version/domain/models/app_version.dart';
import 'package:synk/feat_version/domain/models/newer_app_version.dart';
import 'package:synk/feat_version/domain/models/update_outcome.dart';
import 'package:synk/feat_version/domain/repositories/app_version_repository.dart';
import 'package:synk/feat_version/domain/usecases/get_newer_app_version_interactor.dart';
import 'package:synk/feat_version/domain/usecases/restart_app_interactor.dart';
import 'package:synk/feat_version/domain/usecases/update_to_newest_version_interactor.dart';
import 'package:use_in_case/use_in_case.dart';

part 'app_version_bloc.freezed.dart';
part 'app_version_state.dart';
part 'app_version_event.dart';

class AppVersionBloc(
  AppVersion currentAppVersion,
  final AppVersionRepository repository,
  final NotificationFeature notifications,
) extends Bloc<AppVersionEvent, AppVersionState> {
  final getNewerAppVersion = GetNewerAppVersionInteractor(repository);
  final updateToNewestAppVersion = UpdateToNewestAppVersionInteractor(
    repository,
  );
  final restartApp = RestartAppInteractor(repository);

  var _hasAnnouncedUpdate = false;

  this : super(AppVersionState.initial(currentAppVersion)) {
    on<_OnCheckForUpdates>(_onCheckForUpdates, transformer: droppable());
    on<_OnUpdate>(_onUpdate, transformer: droppable());
    on<_OnRestart>(_onRestart, transformer: droppable());

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
        .getOrElse((_) => const .failedToFetch());

    emit(state.copyWith(newerAppVersion: newerAppVersion));

    final version = newerAppVersion.whenOrNull(
      updateAvailable: (version) => version,
    );

    if (version != null && !_hasAnnouncedUpdate && !state.isReadyToRestart) {
      _hasAnnouncedUpdate = true;
      notifications.notify(
        .new(
          message: 'Synk $version ist verfügbar.',
          severity: .info,
          action: (
            label: 'Aktualisieren',
            onPressed: () => add(const .onUpdate()),
          ),
        ),
      );
    }
  }

  Future<void> _onUpdate(
    _OnUpdate event,
    Emitter<AppVersionState> emit,
  ) async {
    if (state.isReadyToRestart) {
      return;
    }

    final outcome = await updateToNewestAppVersion
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
        .getOrNull();

    if (outcome != UpdateOutcome.installed) {
      return;
    }

    emit(state.copyWith(isReadyToRestart: true));
    notifications.notify(
      .new(
        message: 'Update installiert. Starte Synk neu, um es zu verwenden.',
        severity: .info,
        action: (
          label: 'Neu starten',
          onPressed: () => add(const .onRestart()),
        ),
      ),
    );
  }

  FutureOr<void> _onRestart(_OnRestart event, Emitter<AppVersionState> emit) {
    return restartApp.logger().intercept((e) {
      notifications.notify(.new(message: 'Neustart fehlgeschlagen: $e'));
    }).run();
  }
}
