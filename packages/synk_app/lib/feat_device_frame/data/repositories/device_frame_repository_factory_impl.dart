import 'package:clock/clock.dart';
import 'package:file/file.dart';
import 'package:synk/feat_clipboard/application/host_clipboard.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_frame/application/file_picker.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_repository_impl.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository_factory.dart';
import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';

class const DeviceFrameRepositoryFactoryImpl({
  required final SettingsRepository settingsRepository,
  required final ScreenCaptureEventChannel screenCaptureEventChannel,
  required final HostClipboard hostClipboard,
  required final FilePicker filePicker,
  required final FileSystem fileSystem,
  required final Clock clock,
}) implements DeviceFrameRepositoryFactory {
  @override
  DeviceFrameRepository forConnection(DeviceConnection connection) {
    return DeviceFrameRepositoryImpl(
      deviceId: connection.device.id,
      modelName: connection.device.modelName,
      session: connection.session,
      settingsRepository: settingsRepository,
      screenCaptureEventChannel: screenCaptureEventChannel,
      hostClipboard: hostClipboard,
      filePicker: filePicker,
      fileSystem: fileSystem,
      clock: clock,
    );
  }
}
