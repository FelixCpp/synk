import 'package:clock/clock.dart';
import 'package:file/memory.dart';
import 'package:synk/feat_device_frame/application/file_picker.dart';
import 'package:synk/feat_device_frame/data/repositories/device_frame_factory_impl.dart';
import 'package:synk/feat_device_frame/domain/device_frame_interactors.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_frame/presentation/bloc/device_frame_bloc.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';
import 'package:synk/feat_screen_capture_event/domain/models/screen_capture_event.dart';

import 'fake_device_session.dart';
import 'fake_host_clipboard.dart';
import 'fake_settings_repository.dart';

/// One device frame, wired to fakes a test can both set up and interrogate.
///
/// The repository takes nine collaborators, and every test around the frame
/// needs the same eight of them. Spelling that out per file is what let the
/// fixtures drift apart, so it lives here once: pass the capabilities the
/// device under test has, read the rest off the harness.
final class DeviceFrameHarness {
  DeviceFrameHarness({
    DeviceInteraction? interaction,
    DeviceClipboard? clipboard,
    DeviceAudio? audio,
    DeviceScreenCapture? screenCapture,
    DeviceFileTransfer? fileTransfer,
    FilePicker filePicker = const SystemFilePicker(),
    String screenCaptureSavePath = '/captures',

    /// A fixed moment, for the tests that assert on a capture's filename.
    DateTime? takenAt,
    this.deviceId = const DeviceId('serial-1'),
    this.modelName = 'Test Device',
  }) : settings = FakeSettingsRepository(
         screenCaptureSavePath: screenCaptureSavePath,
       ) {
    session = FakeDeviceSession(
      interaction: interaction,
      clipboard: clipboard,
      audio: audio,
      screenCapture: screenCapture,
      fileTransfer: fileTransfer,
    );

    device = DeviceFrameFactoryImpl(
      settingsRepository: settings,
      screenCaptureEventChannel: events,
      hostClipboard: host,
      filePicker: filePicker,
      fileSystem: fileSystem,
      clock: takenAt == null ? const Clock() : Clock.fixed(takenAt),
    ).forConnection(
      DeviceConnection(
        device: _TestDevice(deviceId, modelName),
        session: session,
        screenSize: session.screenSize,
      ),
    );

    events.observeEvents().listen(announced.add);
    notifications.observeNotifications().listen(
      (notification) => shown.add(notification.message),
    );
  }

  final DeviceId deviceId;
  final String modelName;

  final FakeSettingsRepository settings;
  final host = FakeHostClipboard();
  final fileSystem = MemoryFileSystem();
  final events = ScreenCaptureEventChannel();
  final notifications = NotificationService();

  late final FakeDeviceSession session;
  late final DeviceFrameInteractors device;

  /// Captures the frame announced, in order.
  final announced = <ScreenCaptureEvent>[];

  /// Messages the frame put in front of the user, in order.
  final shown = <String>[];

  DeviceFrameBloc? _bloc;

  /// A bloc on top of [device], built on first use and closed by [dispose].
  DeviceFrameBloc get bloc {
    return _bloc ??= DeviceFrameBloc(
      device: device,
      notifications: notifications,
    );
  }

  Future<void> dispose() async {
    await _bloc?.close();
    await events.dispose();
    await notifications.dispose();
  }
}

class const _TestDevice(
  @override final DeviceId id,
  @override final String modelName,
) implements PluggedDevice {
  @override
  bool get isAuthorized => true;
}
