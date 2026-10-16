import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_version/domain/models/app_version.dart';
import 'package:synk/feat_version/domain/models/newer_app_version.dart';
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
}) implements AppVersionRepository {
  var updates = 0;

  @override
  Future<AppVersion> getCurrentAppVersion() async => _currentAppVersion;

  @override
  Future<NewerAppVersion> getNewerAppVersion() => newerAppVersion();

  @override
  Future<void> updateToNewestRelease({
    required void Function(double progress) onProgress,
  }) async {
    updates++;
    await update?.call(onProgress);
  }
}

void main() {
  test('checks for a newer version on creation', () async {
    final bloc = AppVersionBloc(
      _currentAppVersion,
      _Repository(
        newerAppVersion: () async => const .updateAvailable('0.2.0'),
      ),
      NotificationService(),
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
      NotificationService(),
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
      NotificationService(),
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
      NotificationService(),
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
      NotificationService(),
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
    final notifications = NotificationService();
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

    expect(received, hasLength(1));
  });
}
