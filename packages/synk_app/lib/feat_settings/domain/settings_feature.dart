import 'package:synk/feat_settings/domain/models/settings.dart';

/// What the settings screen can do.
abstract interface class SettingsFeature {
  Stream<Settings> observe();
  Future<void> save(Settings settings);
  Future<void> revealScreenCaptureSavePath();
}
