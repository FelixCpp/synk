import 'package:synk/feat_settings/domain/models/settings.dart';

abstract interface class SettingsRepository {
  Future<Settings> read();
  Stream<Settings> observe();
  Future<void> save(Settings settings);
}
