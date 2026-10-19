import 'package:flutter_test/flutter_test.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:synk/feat_settings/data/repositories/settings_repository_impl.dart';
import 'package:synk/feat_settings/domain/models/mirror_frame_rate.dart';
import 'package:synk/feat_settings/domain/models/mirror_quality.dart';
import 'package:synk/feat_settings/domain/models/settings.dart';
import 'package:synk/feat_settings/domain/models/theme_mode.dart';

final _defaults = Settings.defaults(screenCaptureSavePath: '/tmp/captures');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RxSharedPreferences preferences;
  late SettingsRepositoryImpl repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    preferences = RxSharedPreferences(SharedPreferences.getInstance());
    addTearDown(preferences.dispose);

    repository = SettingsRepositoryImpl(
      preferences: preferences,
      defaults: _defaults,
    );
  });

  group('SettingsRepositoryImpl', () {
    test('falls back to the defaults while nothing was ever stored', () async {
      expect(await repository.read(), _defaults);
    });

    test('reads back every setting it saved', () async {
      final saved = _defaults.copyWith(
        themeMode: ThemeMode.dark,
        screenCaptureSavePath: '/tmp/elsewhere',
        showCapturePreview: false,
        copyScreenshotToClipboard: true,
        recordAudio: false,
        frameRate: MirrorFrameRate.fps30,
        quality: MirrorQuality.high,
        turnDeviceScreenOff: true,
        muteOnConnect: false,
        syncClipboard: false,
        customAdbPath: '/usr/local/bin/adb',
      );

      await repository.save(saved);

      expect(await repository.read(), saved);
    });

    test('drops a custom adb path again', () async {
      await repository.save(_defaults.copyWith(customAdbPath: '/opt/adb'));
      expect((await repository.read()).customAdbPath, '/opt/adb');

      await repository.save(_defaults.copyWith(customAdbPath: null));
      expect((await repository.read()).customAdbPath, isNull);
    });

    test('writes only the settings that changed', () async {
      await repository.save(_defaults.copyWith(syncClipboard: false));

      expect(
        (await preferences.readAll()).keys,
        ['sync_clipboard'],
        reason: 'one toggle must not rewrite all eleven keys',
      );
    });

    test('falls back when a stored value has the wrong type', () async {
      SharedPreferences.setMockInitialValues({'show_capture_preview': 'yes'});

      final settings = await repository.read();

      expect(settings.showCapturePreview, _defaults.showCapturePreview);
    });

    test('ignores a stored value no enum knows any more', () async {
      SharedPreferences.setMockInitialValues({
        'theme_mode': 'solarized',
        'mirror_quality': 'ludicrous',
      });

      final settings = await repository.read();

      expect(settings.themeMode, _defaults.themeMode);
      expect(settings.quality, _defaults.quality);
    });

    test('emits the current settings, then every change', () async {
      final seen = <Settings>[];
      final subscription = repository.observe().listen(seen.add);
      addTearDown(subscription.cancel);

      await pumpEventQueue();
      await repository.save(_defaults.copyWith(syncClipboard: false));
      await pumpEventQueue();

      expect(seen.first, _defaults);
      expect(seen.last.syncClipboard, isFalse);
    });

    test('keeps the mirror options a session is started with', () async {
      await repository.save(
        _defaults.copyWith(
          frameRate: MirrorFrameRate.fps30,
          quality: MirrorQuality.low,
          turnDeviceScreenOff: true,
        ),
      );

      final options = (await repository.read()).mirrorOptions;

      expect(options.maxFps, 30);
      expect(options.videoBitRate, MirrorQuality.low.videoBitRate);
      expect(options.turnDeviceScreenOff, isTrue);
    });
  });
}
