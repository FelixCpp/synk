import 'dart:convert';
import 'dart:io';

import 'package:api_github/api_github.dart';
import 'package:dio/dio.dart';
import 'package:test/test.dart';

import 'fake_http_client_adapter.dart';

final _dmg = GitHubAssetDto(
  name: 'synk-macos-v0.2.0.dmg',
  downloadUrl: Uri.parse(
    'https://github.com/FelixCpp/synk/releases/download/v0.2.0/synk-macos-v0.2.0.dmg',
  ),
);

final _releaseJson = jsonEncode({
  'tag_name': 'v0.2.0',
  'html_url': 'https://github.com/FelixCpp/synk/releases/tag/v0.2.0',
  'assets': [
    {
      'name': _dmg.name,
      'browser_download_url': _dmg.downloadUrl.toString(),
    },
  ],
});

void main() {
  late FakeHttpClientAdapter adapter;

  GitHubReleasesApi apiAnswering(FakeHttpResponse response) {
    adapter = FakeHttpClientAdapter((_) => response);
    return GitHubReleasesApi(
      owner: 'FelixCpp',
      repository: 'synk',
      dio: Dio()..httpClientAdapter = adapter,
    );
  }

  group('fetchLatestRelease', () {
    test('asks GitHub for the latest release of the repository', () async {
      await apiAnswering(
        (statusCode: 200, body: _releaseJson),
      ).fetchLatestRelease();

      expect(
        adapter.requests.single.uri,
        Uri.parse('https://api.github.com/repos/FelixCpp/synk/releases/latest'),
      );
      expect(
        adapter.requests.single.headers['Accept'],
        'application/vnd.github+json',
      );
    });

    test('reads the tag, page and assets', () async {
      final release = await apiAnswering(
        (statusCode: 200, body: _releaseJson),
      ).fetchLatestRelease();

      expect(release.tagName, 'v0.2.0');
      expect(
        release.htmlUrl,
        Uri.parse('https://github.com/FelixCpp/synk/releases/tag/v0.2.0'),
      );
      expect(release.assets.single, _dmg);
    });

    test('throws when GitHub does not answer with a release', () {
      expect(
        apiAnswering((statusCode: 404, body: '{}')).fetchLatestRelease(),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            404,
          ),
        ),
      );
    });
  });

  group('downloadAsset', () {
    late Directory directory;

    setUp(() {
      directory = Directory.systemTemp.createTempSync('api_github_test');
    });

    tearDown(() => directory.deleteSync(recursive: true));

    test('writes the asset to the destination and reports progress', () async {
      final savePath = '${directory.path}/synk.dmg';
      final progress = <(int, int)>[];

      await apiAnswering((statusCode: 200, body: 'dmg')).downloadAsset(
        _dmg,
        savePath,
        onReceiveProgress: (received, total) => progress.add((received, total)),
      );

      expect(adapter.requests.single.uri, _dmg.downloadUrl);
      expect(File(savePath).readAsStringSync(), 'dmg');
      expect(progress.last, (3, 3));
    });

    test('throws and writes nothing when the download fails', () async {
      final savePath = '${directory.path}/synk.dmg';

      await expectLater(
        apiAnswering((statusCode: 500, body: '')).downloadAsset(_dmg, savePath),
        throwsA(isA<DioException>()),
      );
      expect(File(savePath).existsSync(), isFalse);
    });
  });
}
