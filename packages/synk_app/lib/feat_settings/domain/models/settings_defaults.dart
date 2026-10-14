import 'package:synk/feat_settings/domain/models/mirror_frame_rate.dart';
import 'package:synk/feat_settings/domain/models/mirror_quality.dart';

/// What every setting falls back to before the user has touched it.
///
/// Kept in one place because the repository, the initial bloc state and the
/// startup read of the adb path all have to agree on them.
class SettingsDefaults {
  const SettingsDefaults._();

  static const showCapturePreview = true;
  static const frameRate = MirrorFrameRate.fps60;
  static const quality = MirrorQuality.medium;
  static const turnDeviceScreenOff = false;
  static const muteOnConnect = true;
  static const syncClipboard = true;
}
