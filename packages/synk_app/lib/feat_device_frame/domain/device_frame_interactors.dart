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

/// The interactors a frame dispatches through, one per entry in
/// [DeviceFrameFeature].
///
/// They hold no rules — those live in the feature. What they add is the
/// decorator chain the blocs rely on: `.logger()`, `.busyStateChange()` and
/// `runReporting`, so a failure becomes a logged line and a message to the
/// user instead of a crash.
class const DeviceFrameInteractors({
  required final bool isAudioMuted,
  required final double audioVolume,
  required final SimulateKeyEventInteractor simulateKeyEvent,
  required final SimulatePointerEventInteractor simulatePointerEvent,
  required final SimulatePinchEventInteractor simulatePinchEvent,
  required final CaptureScreenshotInteractor captureScreenshot,
  required final StartRecordingInteractor startRecording,
  required final StopRecordingInteractor stopRecording,
  required final SetAudioMutedInteractor setAudioMuted,
  required final SetAudioVolumeInteractor setAudioVolume,
  required final SendFilesInteractor sendFiles,
  required final SendPickedApkInteractor sendPickedApk,
  required final SendPickedFileInteractor sendPickedFile,
  required final NavigateInteractor navigate,
  required final PressPowerButtonInteractor pressPowerButton,
});
