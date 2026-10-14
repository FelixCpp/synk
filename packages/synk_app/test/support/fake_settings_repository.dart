import 'package:synk/feat_settings/domain/models/settings.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';

class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository({
    String screenCaptureSavePath = '/tmp/synk-test-captures',
  }) : current = Settings.defaults(
         screenCaptureSavePath: screenCaptureSavePath,
       );

  Settings current;

  void update(Settings Function(Settings settings) change) {
    current = change(current);
  }

  @override
  Future<Settings> read() async => current;

  @override
  Stream<Settings> observe() => Stream.value(current);

  @override
  Future<void> save(Settings settings) async {
    current = settings;
  }
}
