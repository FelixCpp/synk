import 'package:flutter_test/flutter_test.dart';
import 'package:clock/clock.dart';
import 'package:file/memory.dart';
import 'package:synk/feat_device_frame/application/file_picker.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository_impl.dart';
import 'package:synk/feat_device_frame/presentation/bloc/device_frame_bloc.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';

import '../support/fake_device_session.dart';
import '../support/fake_host_clipboard.dart';
import '../support/fake_settings_repository.dart';

void main() {
  group('DeviceFrameBloc audio', () {
    test('reports the mute state a session already has', () async {
      final audio = FakeAudio()..isAudioMuted = false;
      final bloc = _blocFor(audio);
      addTearDown(bloc.close);

      await pumpEventQueue();

      expect(bloc.state.isAudioMuted, isFalse);
    });

    test(
      'leaves the session alone, however the preference is set',
      () async {
        // A device can carry more than one frame: the maximized view builds a
        // second one for the same session. If setup imposed the connect-time
        // preference, opening it would silence audio the user just turned on.
        final audio = FakeAudio()..isAudioMuted = false;
        final bloc = _blocFor(audio);
        addTearDown(bloc.close);

        await pumpEventQueue();

        expect(audio.isAudioMuted, isFalse);
      },
    );

    test('unmuting in the frame reaches the session', () async {
      // The state a fresh session is handed by the connect-time preference.
      final audio = FakeAudio()..isAudioMuted = true;
      final bloc = _blocFor(audio);
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(bloc.state.isAudioMuted, isTrue);

      bloc.add(const DeviceFrameEvent.onToggleAudioMute());
      await pumpEventQueue();

      expect(audio.isAudioMuted, isFalse);
      expect(bloc.state.isAudioMuted, isFalse);
    });

    test('muting again reaches the session too', () async {
      final audio = FakeAudio()..isAudioMuted = false;
      final bloc = _blocFor(audio);
      addTearDown(bloc.close);
      await pumpEventQueue();

      bloc.add(const DeviceFrameEvent.onToggleAudioMute());
      await pumpEventQueue();

      expect(audio.isAudioMuted, isTrue);
    });

    test('reports the volume a session already has', () async {
      final audio = FakeAudio()..audioVolume = 0.4;
      final bloc = _blocFor(audio);
      addTearDown(bloc.close);

      await pumpEventQueue();

      expect(bloc.state.audioVolume, 0.4);
    });

    test('changing the volume reaches the session', () async {
      final audio = FakeAudio()..isAudioMuted = false;
      final bloc = _blocFor(audio);
      addTearDown(bloc.close);
      await pumpEventQueue();

      bloc.add(const DeviceFrameEvent.onAudioVolumeChanged(0.3));
      await pumpEventQueue();

      expect(audio.audioVolume, 0.3);
      expect(bloc.state.audioVolume, 0.3);
    });

    test('turning the volume up while muted unmutes', () async {
      final audio = FakeAudio()..isAudioMuted = true;
      final bloc = _blocFor(audio);
      addTearDown(bloc.close);
      await pumpEventQueue();

      bloc.add(const DeviceFrameEvent.onAudioVolumeChanged(0.6));
      await pumpEventQueue();

      expect(audio.isAudioMuted, isFalse);
      expect(bloc.state.isAudioMuted, isFalse);
    });

    test('turning the volume down to zero leaves mute alone', () async {
      final audio = FakeAudio()..isAudioMuted = true;
      final bloc = _blocFor(audio);
      addTearDown(bloc.close);
      await pumpEventQueue();

      bloc.add(const DeviceFrameEvent.onAudioVolumeChanged(0.0));
      await pumpEventQueue();

      expect(audio.isAudioMuted, isTrue);
      expect(audio.audioVolume, 0.0);
    });
  });
}

DeviceFrameBloc _blocFor(FakeAudio audio) {
  final notifications = NotificationService();
  addTearDown(notifications.dispose);

  return DeviceFrameBloc(
    repository: DeviceFrameRepositoryImpl(
      deviceId: const DeviceId('serial-1'),
      modelName: 'Test Device',
      session: FakeDeviceSession(audio: audio),
      settingsRepository: FakeSettingsRepository(),
      screenCaptureEventChannel: ScreenCaptureEventChannel(),
      hostClipboard: FakeHostClipboard(),
      filePicker: const SystemFilePicker(),
      fileSystem: MemoryFileSystem(),
      clock: const Clock(),
    ),
    notifications: notifications,
  );
}
