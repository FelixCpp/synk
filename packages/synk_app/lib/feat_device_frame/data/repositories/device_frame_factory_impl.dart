import 'package:clock/clock.dart';
import 'package:file/file.dart';
import 'package:synk/feat_clipboard/application/host_clipboard.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_frame/application/file_picker.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository_impl.dart';
import 'package:synk/feat_device_frame/data/screen_capture_store.dart';
import 'package:synk/feat_device_frame/domain/device_clipboard_sync.dart';
import 'package:synk/feat_device_frame/domain/device_frame_interactors.dart';
import 'package:synk/feat_device_frame/domain/models/running_recording.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_factory.dart';
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
  required final HostClipboard hostClipboard,
  required final FilePicker filePicker,
  required final FileSystem fileSystem,
  required final Clock clock,
}) implements DeviceFrameFactory {
  @override
  DeviceFrameInteractors forConnection(DeviceConnection connection) {
    final device = DeviceFrameRepositoryImpl(
      deviceId: connection.device.id,
      session: connection.session,
    );

    final captures = ScreenCaptureStore(
      deviceId: connection.device.id,
      modelName: connection.device.modelName,
      settingsRepository: settingsRepository,
      events: screenCaptureEventChannel,
      fileSystem: fileSystem,
      clock: clock,
    );

    final running = RunningRecording();
    final sendFiles = SendFilesInteractor(device);

    return DeviceFrameInteractors(
      isAudioMuted: device.isAudioMuted,
      audioVolume: device.audioVolume,
      simulateKeyEvent: SimulateKeyEventInteractor(
        repository: device,
        clipboardSync: DeviceClipboardSync(hostClipboard),
        settingsRepository: settingsRepository,
      ),
      simulatePointerEvent: SimulatePointerEventInteractor(device),
      simulatePinchEvent: SimulatePinchEventInteractor(device),
      captureScreenshot: CaptureScreenshotInteractor(
        repository: device,
        captures: captures,
        hostClipboard: hostClipboard,
        settingsRepository: settingsRepository,
      ),
      startRecording: StartRecordingInteractor(
        repository: device,
        captures: captures,
        settingsRepository: settingsRepository,
        running: running,
      ),
      stopRecording: StopRecordingInteractor(
        repository: device,
        captures: captures,
        running: running,
      ),
      setAudioMuted: SetAudioMutedInteractor(device),
      setAudioVolume: SetAudioVolumeInteractor(device),
      sendFiles: sendFiles,
      sendPickedApk: SendPickedApkInteractor(
        filePicker: filePicker,
        sendFiles: sendFiles,
      ),
      sendPickedFile: SendPickedFileInteractor(
        filePicker: filePicker,
        sendFiles: sendFiles,
      ),
      navigate: NavigateInteractor(device),
      pressPowerButton: PressPowerButtonInteractor(device),
    );
  }
}
