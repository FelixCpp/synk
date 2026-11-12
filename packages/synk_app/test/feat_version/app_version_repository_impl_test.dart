import 'package:api_github/api_github.dart';
import 'package:dio/dio.dart';
import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform/testing.dart';
import 'package:synk/feat_screen_capture_preview/application/system_file_opener.dart';
import 'package:synk/feat_version/data/app_bundle_installer.dart';
import 'package:synk/feat_version/data/repositories/app_version_repository_impl.dart';
import 'package:synk/feat_version/domain/models/newer_app_version.dart';
import 'package:synk/feat_version/domain/models/update_outcome.dart';

import '../support/fake_process_manager.dart';

final _pageUrl = Uri.parse(
  'https://github.com/FelixCpp/synk/releases/tag/v0.2.0',
);
final _dmg = GitHubAssetDto(
  name: 'synk-macos-v0.2.0.dmg',
  downloadUrl: Uri.parse(
    'https://github.com/FelixCpp/synk/releases/download/v0.2.0/synk-macos-v0.2.0.dmg',
  ),
);

class _ReleasesApi({
  required final GitHubReleaseDto release,
  final List<(int, int)> progress = const [],
}) implements GitHubReleasesApi {
  final downloads = <(GitHubAssetDto, String)>[];

  @override
  String get owner => 'FelixCpp';

  @override
  String get repository => 'synk';

  @override
  Dio get dio => throw UnimplementedError();

  @override
  Future<GitHubReleaseDto> fetchLatestRelease() async => release;

  @override
  Future<void> downloadAsset(
    GitHubAssetDto asset,
    String savePath, {
    ProgressCallback? onReceiveProgress,
  }) async {
    downloads.add((asset, savePath));
    for (final (received, total) in progress) {
      onReceiveProgress?.call(received, total);
    }
  }
}

GitHubReleaseDto _release({
  String tag = 'v0.2.0',
  List<GitHubAssetDto>? assets,
}) {
  return GitHubReleaseDto(
    tagName: tag,
    htmlUrl: _pageUrl,
    assets: assets ?? [_dmg],
  );
}

void main() {
  late FakeProcessManager processManager;
  late MemoryFileSystem fileSystem;
  late bool isBundleWritable;
  late int quits;

  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'synk',
      packageName: 'dev.synk',
      version: '0.1.1',
      buildNumber: '5',
      buildSignature: '',
    );
    isBundleWritable = false;
    quits = 0;
    fileSystem = MemoryFileSystem();
    fileSystem.directory('/Applications/synk.app').createSync(recursive: true);
    fileSystem.systemTempDirectory.createSync(recursive: true);
    processManager = FakeProcessManager(
      respond: (command) {
        switch (command) {
          case ['test', '-w', ...]:
            return (exitCode: isBundleWritable ? 0 : 1, stdout: '', stderr: '');
          case ['hdiutil', 'attach', ...]:
            final mountPoint = command[command.indexOf('-mountpoint') + 1];
            fileSystem
                .directory('$mountPoint/synk.app')
                .createSync(recursive: true);
          case ['ditto', _, final to]:
            fileSystem.directory(to).createSync(recursive: true);
        }

        return fakeSuccess;
      },
    );
  });

  AppVersionRepositoryImpl repository(GitHubReleasesApi releasesApi) {
    return AppVersionRepositoryImpl(
      releasesApi: releasesApi,
      fileOpener: SystemFileOpener(
        processManager: processManager,
        platform: TestNativePlatform(operatingSystem: NativePlatform.macOS),
      ),
      installer: AppBundleInstaller(
        processManager: processManager,
        fileSystem: fileSystem,
        bundlePath: '/Applications/synk.app',
      ),
      quit: () async => quits++,
      downloadDirectory: '/downloads',
    );
  }

  test('reports a newer release', () async {
    final result = await repository(
      _ReleasesApi(release: _release()),
    ).getNewerAppVersion();

    expect(result, const NewerAppVersion.updateAvailable('0.2.0'));
  });

  test('is up to date when the latest release is the installed one', () async {
    final result = await repository(
      _ReleasesApi(release: _release(tag: 'v0.1.1')),
    ).getNewerAppVersion();

    expect(result, const NewerAppVersion.upToDate());
  });

  test(
    'downloads the dmg and opens it when Synk cannot replace itself',
    () async {
      final releasesApi = _ReleasesApi(release: _release());

      final outcome = await repository(
        releasesApi,
      ).updateToNewestRelease(onProgress: (_) {});

      expect(outcome, UpdateOutcome.installerOpened);
      expect(releasesApi.downloads, [
        (_dmg, '/downloads/synk-macos-v0.2.0.dmg'),
      ]);
      expect(processManager.commands.last, [
        'open',
        '/downloads/synk-macos-v0.2.0.dmg',
      ]);
    },
  );

  test('installs the dmg over the running app when it can', () async {
    isBundleWritable = true;

    final outcome = await repository(
      _ReleasesApi(release: _release()),
    ).updateToNewestRelease(onProgress: (_) {});

    expect(outcome, UpdateOutcome.installed);
    expect(
      processManager.commands.where((command) => command.first == 'open'),
      isEmpty,
    );
    expect(
      processManager.commands,
      contains(
        containsAllInOrder([
          'hdiutil',
          'attach',
          '/downloads/synk-macos-v0.2.0.dmg',
        ]),
      ),
    );
  });

  test('relaunches before it quits', () async {
    await repository(_ReleasesApi(release: _release())).restart();

    expect(processManager.commands.single.first, '/bin/sh');
    expect(quits, 1);
  });

  test('reports each whole percent of the download once', () async {
    final progress = <double>[];

    await repository(
      _ReleasesApi(
        release: _release(),
        progress: const [(0, 200), (1, 200), (2, 200), (3, 200), (200, 200)],
      ),
    ).updateToNewestRelease(onProgress: progress.add);

    expect(progress, [0.0, 0.01, 1.0]);
  });

  test('reports no progress when the size is unknown', () async {
    final progress = <double>[];

    await repository(
      _ReleasesApi(release: _release(), progress: const [(100, -1)]),
    ).updateToNewestRelease(onProgress: progress.add);

    expect(progress, isEmpty);
  });

  test('opens the release page when the release has no dmg', () async {
    final outcome = await repository(
      _ReleasesApi(release: _release(assets: const [])),
    ).updateToNewestRelease(onProgress: (_) {});

    expect(outcome, UpdateOutcome.installerOpened);
    expect(processManager.commands, [
      ['open', _pageUrl.toString()],
    ]);
  });

  group('isNewerVersion', () {
    test('compares each part numerically', () {
      expect(isNewerVersion('0.10.0', than: '0.9.9'), isTrue);
      expect(isNewerVersion('1.0.0', than: '0.99.99'), isTrue);
      expect(isNewerVersion('0.1.2', than: '0.1.1'), isTrue);
    });

    test('is false for the same or an older version', () {
      expect(isNewerVersion('0.1.1', than: '0.1.1'), isFalse);
      expect(isNewerVersion('0.1.0', than: '0.1.1'), isFalse);
    });

    test('ignores build numbers', () {
      expect(isNewerVersion('0.1.1+9', than: '0.1.1+5'), isFalse);
    });

    test('rejects versions that are not major.minor.patch', () {
      expect(() => isNewerVersion('1.0', than: '0.1.1'), throwsFormatException);
    });
  });
}
