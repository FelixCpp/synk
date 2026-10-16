import 'package:api_github/api_github.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:synk/feat_screen_capture_preview/application/system_file_opener.dart';
import 'package:synk/feat_version/domain/models/app_version.dart';
import 'package:synk/feat_version/domain/models/newer_app_version.dart';
import 'package:synk/feat_version/domain/repositories/app_version_repository.dart';

class const AppVersionRepositoryImpl({
  required final GitHubReleasesApi releasesApi,
  required final SystemFileOpener fileOpener,
  required final String downloadDirectory,
}) implements AppVersionRepository {
  @override
  Future<AppVersion> getCurrentAppVersion() async {
    final info = await PackageInfo.fromPlatform();

    return AppVersion(
      appName: info.appName,
      packageName: info.packageName,
      version: info.version,
      buildNumber: info.buildNumber,
    );
  }

  @override
  Future<NewerAppVersion> getNewerAppVersion() async {
    final current = await getCurrentAppVersion();
    final release = await releasesApi.fetchLatestRelease();
    final version = _stripTagPrefix(release.tagName);

    if (isNewerVersion(version, than: current.version)) {
      return NewerAppVersion.updateAvailable(version);
    }

    return const NewerAppVersion.upToDate();
  }

  @override
  Future<void> updateToNewestRelease({
    required void Function(double progress) onProgress,
  }) async {
    final release = await releasesApi.fetchLatestRelease();
    final dmg = release.assets
        .where((asset) => asset.name.endsWith('.dmg'))
        .firstOrNull;

    if (dmg == null) {
      return fileOpener.open(release.htmlUrl.toString());
    }

    final savePath = path.join(downloadDirectory, dmg.name);
    var reportedPercent = -1;
    await releasesApi.downloadAsset(
      dmg,
      savePath,
      onReceiveProgress: (received, total) {
        if (total <= 0) {
          return;
        }

        final percent = received * 100 ~/ total;
        if (percent != reportedPercent) {
          reportedPercent = percent;
          onProgress(percent / 100);
        }
      },
    );
    await fileOpener.open(savePath);
  }
}

String _stripTagPrefix(String tag) {
  return tag.startsWith('v') ? tag.substring(1) : tag;
}

bool isNewerVersion(String candidate, {required String than}) {
  final candidateParts = _parseVersion(candidate);
  final currentParts = _parseVersion(than);

  for (var i = 0; i < 3; i++) {
    if (candidateParts[i] != currentParts[i]) {
      return candidateParts[i] > currentParts[i];
    }
  }

  return false;
}

List<int> _parseVersion(String version) {
  final parts = version.split('+').first.split('.').map(int.parse).toList();

  if (parts.length != 3) {
    throw FormatException('Not a major.minor.patch version', version);
  }

  return parts;
}
