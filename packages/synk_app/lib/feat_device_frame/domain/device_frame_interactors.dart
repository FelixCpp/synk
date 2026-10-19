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

/// Everything one frame can ask of its device, already wired.
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
