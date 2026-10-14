import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';

import '../support/fake_device_session.dart';
import '../support/fake_settings_repository.dart';

const _deviceId = DeviceId('serial-1');

DeviceFrameRepository _repositoryFor(
  FakeAudio audio, {
  required bool muteOnConnect,
}) {
  return DeviceFrameRepository(
    deviceId: _deviceId,
    modelName: 'Test Device',
    session: FakeDeviceSession(audio: audio),
    settingsRepository: FakeSettingsRepository(muteOnConnect: muteOnConnect),
    screenCaptureEventChannel: ScreenCaptureEventChannel(),
  );
}

void main() {
  group('DeviceFrameRepository.applyAudioMutePreference', () {
    test('mutes a fresh session when the preference asks for it', () async {
      final audio = FakeAudio()..isAudioMuted = false;

      final muted = await _repositoryFor(
        audio,
        muteOnConnect: true,
      ).applyAudioMutePreference();

      expect(audio.isAudioMuted, isTrue);
      expect(muted, isTrue);
    });

    test('unmutes a fresh session when the preference asks for it', () async {
      final audio = FakeAudio()..isAudioMuted = true;

      final muted = await _repositoryFor(
        audio,
        muteOnConnect: false,
      ).applyAudioMutePreference();

      expect(audio.isAudioMuted, isFalse);
      expect(muted, isFalse);
    });

    test('reports a session without audio as muted', () async {
      final repository = DeviceFrameRepository(
        deviceId: _deviceId,
        modelName: 'Test Device',
        session: FakeDeviceSession(),
        settingsRepository: FakeSettingsRepository(muteOnConnect: false),
        screenCaptureEventChannel: ScreenCaptureEventChannel(),
      );

      expect(await repository.applyAudioMutePreference(), isTrue);
    });
  });
}
