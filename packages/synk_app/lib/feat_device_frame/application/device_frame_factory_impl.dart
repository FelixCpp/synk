import 'package:clock/clock.dart';
import 'package:file/file.dart';
import 'package:synk/feat_clipboard/domain/clipboard_feature.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_frame/application/file_picker.dart';
import 'package:synk/feat_device_frame/application/device_frame_feature_impl.dart';
import 'package:synk/feat_device_frame/data/screen_capture_store.dart';
import 'package:synk/feat_device_frame/domain/device_frame_interactors.dart';
import 'package:synk/feat_device_frame/domain/device_frame_factory.dart';
import 'package:synk/feat_device_frame/domain/usecases/capture_screenshot_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/navigate_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/press_power_button_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/send_files_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/send_picked_apk_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/send_picked_file_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/set_audio_muted_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/set_audio_volume_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/simulate_key_event_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/simulate_pinch_event_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/simulate_pointer_event_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/start_recording_interactor.dart';
import 'package:synk/feat_device_frame/domain/usecases/stop_recording_interactor.dart';
import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';

class const DeviceFrameFactoryImpl({
  required final SettingsRepository settingsRepository,
  required final ScreenCaptureEventChannel screenCaptureEventChannel,
  required final ClipboardFeature clipboard,
  required final FilePicker filePicker,
  required final FileSystem fileSystem,
  required final Clock clock,
}) implements DeviceFrameFactory {
  @override
  DeviceFrameInteractors forConnection(DeviceConnection connection) {
    final captures = ScreenCaptureStore(
      deviceId: connection.device.id,
      modelName: connection.device.modelName,
      settingsRepository: settingsRepository,
      events: screenCaptureEventChannel,
      fileSystem: fileSystem,
      clock: clock,
    );

    final feature = DeviceFrameFeatureImpl(
      deviceId: connection.device.id,
      session: connection.session,
      captures: captures,
      settingsRepository: settingsRepository,
      clipboard: clipboard,
      filePicker: filePicker,
    );

    return DeviceFrameInteractors(
      isAudioMuted: feature.isAudioMuted,
      audioVolume: feature.audioVolume,
      simulateKeyEvent: SimulateKeyEventInteractor(feature),
      simulatePointerEvent: SimulatePointerEventInteractor(feature),
      simulatePinchEvent: SimulatePinchEventInteractor(feature),
      captureScreenshot: CaptureScreenshotInteractor(feature),
      startRecording: StartRecordingInteractor(feature),
      stopRecording: StopRecordingInteractor(feature),
      setAudioMuted: SetAudioMutedInteractor(feature),
      setAudioVolume: SetAudioVolumeInteractor(feature),
      sendFiles: SendFilesInteractor(feature),
      sendPickedApk: SendPickedApkInteractor(feature),
      sendPickedFile: SendPickedFileInteractor(feature),
      navigate: NavigateInteractor(feature),
      pressPowerButton: PressPowerButtonInteractor(feature),
    );
  }
}
