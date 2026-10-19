import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_frame/presentation/bloc/device_frame_bloc.dart';

import '../support/device_frame_harness.dart';
import '../support/fake_device_session.dart';

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

    test('takes the mute back when the device refuses it', () async {
      final audio = FakeAudio()..isAudioMuted = false;
      final bloc = _blocFor(audio);
      addTearDown(bloc.close);
      await pumpEventQueue();

      audio.failWith = Exception('no audio route');
      bloc.add(const DeviceFrameEvent.onToggleAudioMute());
      await pumpEventQueue();

      expect(
        bloc.state.isAudioMuted,
        isFalse,
        reason: 'the button must not claim a mute the device never applied',
      );
    });

    test('takes the volume back when the device refuses it', () async {
      final audio = FakeAudio()
        ..isAudioMuted = false
        ..audioVolume = 0.8;
      final bloc = _blocFor(audio);
      addTearDown(bloc.close);
      await pumpEventQueue();

      audio.failWith = Exception('no audio route');
      bloc.add(const DeviceFrameEvent.onAudioVolumeChanged(0.2));
      await pumpEventQueue();

      expect(bloc.state.audioVolume, 0.8);
    });

    test('says so when the device refuses a mute', () async {
      final audio = FakeAudio()..isAudioMuted = false;
      final harness = DeviceFrameHarness(audio: audio);
      addTearDown(harness.dispose);
      final bloc = harness.bloc;
      await pumpEventQueue();

      audio.failWith = Exception('no audio route');
      bloc.add(const DeviceFrameEvent.onToggleAudioMute());
      await pumpEventQueue();

      // Rolling the state back must not cost the user the message: the
      // rollback intercept has to pass consume: false to let this through.
      expect(harness.shown, ['Der Ton ließ sich nicht umschalten.']);
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

DeviceFrameBloc _blocFor(FakeAudio audio, {DeviceFrameHarness? harness}) {
  final it = harness ?? DeviceFrameHarness(audio: audio);
  addTearDown(it.dispose);

  return it.bloc;
}
