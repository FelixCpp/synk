import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_notifications/application/notification_feature_impl.dart';
import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_version/domain/models/app_version.dart';
import 'package:synk/feat_version/domain/models/newer_app_version.dart';
import 'package:synk/feat_version/domain/models/update_outcome.dart';
import 'package:synk/feat_version/domain/repositories/app_version_repository.dart';
import 'package:synk/feat_version/presentation/bloc/app_version_bloc.dart';

const _currentAppVersion = AppVersion(
  appName: 'synk',
  packageName: 'dev.synk',
  version: '0.1.1',
  buildNumber: '5',
);

class _Repository({
  required final Future<NewerAppVersion> Function() newerAppVersion,
  final Future<void> Function(void Function(double progress) onProgress)?
  update,
  final UpdateOutcome outcome = .installerOpened,
}) implements AppVersionRepository {
  var updates = 0;
  var restarts = 0;

  @override
  Future<AppVersion> getCurrentAppVersion() async => _currentAppVersion;

  @override
  Future<NewerAppVersion> getNewerAppVersion() => newerAppVersion();

  @override
  Future<UpdateOutcome> updateToNewestRelease({
    required void Function(double progress) onProgress,
  }) async {
    updates++;
    await update?.call(onProgress);
    return outcome;
  }

  @override
  Future<void> restart() async => restarts++;
}

void main() {
  test('checks for a newer version on creation', () async {
    final bloc = AppVersionBloc(
      _currentAppVersion,
      _Repository(
        newerAppVersion: () async => const .updateAvailable('0.2.0'),
      ),
      NotificationFeatureImpl(),
    );
    addTearDown(bloc.close);

    expect(bloc.state.newerAppVersion, isNull);
    await expectLater(
      bloc.stream.map((state) => state.newerAppVersion),
      emitsThrough(const NewerAppVersion.updateAvailable('0.2.0')),
    );
  });

  test('reports a failed check instead of throwing', () async {
    final bloc = AppVersionBloc(
      _currentAppVersion,
      _Repository(newerAppVersion: () async => throw Exception('offline')),
      NotificationFeatureImpl(),
    );
    addTearDown(bloc.close);

    await expectLater(
      bloc.stream.map((state) => state.newerAppVersion),
      emitsThrough(const NewerAppVersion.failedToFetch()),
    );
  });

  test('is updating while the update runs', () async {
    final repository = _Repository(
      newerAppVersion: () async => const .updateAvailable('0.2.0'),
    );
    final bloc = AppVersionBloc(
      _currentAppVersion,
      repository,
      NotificationFeatureImpl(),
    );
    addTearDown(bloc.close);

    bloc.add(const .onUpdate());

    await expectLater(
      bloc.stream.map((state) => state.isUpdating).distinct(),
      emitsInOrder([mayEmit(false), true, false]),
    );
    expect(repository.updates, 1);
  });

  test('shows the download progress while updating', () async {
    final bloc = AppVersionBloc(
      _currentAppVersion,
      _Repository(
        newerAppVersion: () async => const .updateAvailable('0.2.0'),
        update: (onProgress) async {
          onProgress(0.5);
          await pumpEventQueue();
        },
      ),
      NotificationFeatureImpl(),
    );
    addTearDown(bloc.close);

    bloc.add(const .onUpdate());

    await expectLater(
      bloc.stream.map((state) => (state.isUpdating, state.downloadProgress)),
      emitsThrough((true, 0.5)),
    );
    await bloc.stream.firstWhere((state) => !state.isUpdating);
    expect(bloc.state.downloadProgress, isNull);
  });

  test('can update again after an update finished', () async {
    final repository = _Repository(
      newerAppVersion: () async => const .updateAvailable('0.2.0'),
      update: (onProgress) async => onProgress(1),
    );
    final bloc = AppVersionBloc(
      _currentAppVersion,
      repository,
      NotificationFeatureImpl(),
    );
    addTearDown(bloc.close);

    for (var i = 0; i < 2; i++) {
      bloc.add(const .onUpdate());
      await bloc.stream.firstWhere((state) => state.isUpdating);
      await bloc.stream.firstWhere((state) => !state.isUpdating);
    }

    expect(repository.updates, 2);
  });

  test('notifies when the update fails', () async {
    final notifications = NotificationFeatureImpl();
    final received = <AppNotification>[];
    notifications.observeNotifications().listen(received.add);
    final bloc = AppVersionBloc(
      _currentAppVersion,
      _Repository(
        newerAppVersion: () async => const .upToDate(),
        update: (_) async => throw Exception('no network'),
      ),
      notifications,
    );
    addTearDown(bloc.close);

    bloc.add(const .onUpdate());
    await bloc.stream.firstWhere((state) => !state.isUpdating);
    await pumpEventQueue();

    expect(
      received.where((notification) => !notification.isBusy),
      hasLength(1),
    );
  });

  test('shows the update running on the stack until it is done', () async {
    final notifications = NotificationFeatureImpl();
    final seen = <String>[];
    notifications.observeStack().listen(
      (stack) => seen.addAll(
        stack.entries
            .map((entry) => entry.notification)
            .where((notification) => notification.isBusy)
            .map((notification) => notification.message),
      ),
    );
    final bloc = AppVersionBloc(
      _currentAppVersion,
      _Repository(
        newerAppVersion: () async => const .upToDate(),
        update: (onProgress) async {
          onProgress(0.5);
          await pumpEventQueue();
          onProgress(1);
          await pumpEventQueue();
        },
        outcome: .installed,
      ),
      notifications,
    );
    addTearDown(bloc.close);

    bloc.add(const .onUpdate());
    await bloc.stream.firstWhere((state) => state.isReadyToRestart);
    await pumpEventQueue();

    expect(
      seen.toSet(),
      containsAllInOrder([
        'Update wird geladen …',
        'Update wird geladen … 50 %',
        'Update wird installiert …',
      ]),
    );
    final stack = await notifications.observeStack().first;
    expect(stack.entries.map((entry) => entry.notification.isBusy), [false]);
  });

  test('announces a newer version once with an update action', () async {
    final notifications = NotificationFeatureImpl();
    final received = <AppNotification>[];
    notifications.observeNotifications().listen(received.add);
    final repository = _Repository(
      newerAppVersion: () async => const .updateAvailable('0.2.0'),
    );
    final bloc = AppVersionBloc(_currentAppVersion, repository, notifications);
    addTearDown(bloc.close);

    await bloc.stream.firstWhere((state) => state.newerAppVersion != null);
    bloc.add(const .onCheckForUpdates());
    await bloc.stream.firstWhere((state) => state.newerAppVersion == null);
    await bloc.stream.firstWhere((state) => state.newerAppVersion != null);
    await pumpEventQueue();

    expect(received, hasLength(1));
    expect(received.single.severity, NotificationSeverity.info);
    expect(received.single.action?.label, 'Aktualisieren');

    received.single.action!.onPressed();
    await bloc.stream.firstWhere((state) => !state.isUpdating);
    expect(repository.updates, 1);
  });

  test('announces nothing when Synk is up to date', () async {
    final notifications = NotificationFeatureImpl();
    final received = <AppNotification>[];
    notifications.observeNotifications().listen(received.add);
    final bloc = AppVersionBloc(
      _currentAppVersion,
      _Repository(newerAppVersion: () async => const .upToDate()),
      notifications,
    );
    addTearDown(bloc.close);

    await bloc.stream.firstWhere((state) => state.newerAppVersion != null);
    await pumpEventQueue();

    expect(received, isEmpty);
  });

  test('offers a restart once the update is installed', () async {
    final notifications = NotificationFeatureImpl();
    final received = <AppNotification>[];
    final repository = _Repository(
      newerAppVersion: () async => const .upToDate(),
      outcome: .installed,
    );
    final bloc = AppVersionBloc(_currentAppVersion, repository, notifications);
    addTearDown(bloc.close);
    await bloc.stream.firstWhere((state) => state.newerAppVersion != null);
    notifications.observeNotifications().listen(received.add);

    bloc.add(const .onUpdate());
    await bloc.stream.firstWhere((state) => state.isReadyToRestart);
    await pumpEventQueue();

    final restart = received.lastWhere((notification) => !notification.isBusy);
    expect(restart.action?.label, 'Neu starten');

    restart.action!.onPressed();
    await pumpEventQueue();
    expect(repository.restarts, 1);
  });

  test('stays ready to update when the installer was only opened', () async {
    final repository = _Repository(
      newerAppVersion: () async => const .upToDate(),
    );
    final bloc = AppVersionBloc(
      _currentAppVersion,
      repository,
      NotificationFeatureImpl(),
    );
    addTearDown(bloc.close);

    bloc.add(const .onUpdate());
    await bloc.stream.firstWhere((state) => state.isUpdating);
    await bloc.stream.firstWhere((state) => !state.isUpdating);

    expect(bloc.state.isReadyToRestart, isFalse);
  });
}
