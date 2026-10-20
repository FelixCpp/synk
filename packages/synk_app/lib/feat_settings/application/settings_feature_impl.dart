import 'package:synk/feat_screen_capture_preview/application/system_file_opener.dart';
import 'package:synk/feat_settings/domain/models/settings.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:synk/feat_settings/domain/settings_feature.dart';

class const SettingsFeatureImpl({
  required final SettingsRepository settings,
  required final SystemFileOpener fileOpener,
}) implements SettingsFeature {
  @override
  Stream<Settings> observe() => settings.observe();

  @override
  Future<void> save(Settings next) => settings.save(next);

  @override
  Future<void> revealScreenCaptureSavePath() async {
    final current = await settings.read();
    await fileOpener.open(current.screenCaptureSavePath);
  }
}
