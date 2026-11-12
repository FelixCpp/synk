import 'package:synk/feat_version/domain/models/app_version.dart';
import 'package:synk/feat_version/domain/models/newer_app_version.dart';
import 'package:synk/feat_version/domain/models/update_outcome.dart';

abstract interface class AppVersionRepository {
  Future<AppVersion> getCurrentAppVersion();
  Future<UpdateOutcome> updateToNewestRelease({
    required void Function(double progress) onProgress,
  });
  Future<void> restart();
  Future<NewerAppVersion> getNewerAppVersion();
}
