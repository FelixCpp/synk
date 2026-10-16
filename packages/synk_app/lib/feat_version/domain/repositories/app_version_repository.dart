import 'package:synk/feat_version/domain/models/app_version.dart';
import 'package:synk/feat_version/domain/models/newer_app_version.dart';

abstract interface class AppVersionRepository {
  Future<AppVersion> getCurrentAppVersion();
  Future<void> updateToNewestRelease({
    required void Function(double progress) onProgress,
  });
  Future<NewerAppVersion> getNewerAppVersion();
}
