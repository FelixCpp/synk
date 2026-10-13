import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/application/agents/audio_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/clipboard_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/file_transfer_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/interaction_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/screen_capture_device_agent.dart';
import 'package:synk/feat_device_platform/application/device_agent.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/domain/models/native_texture_id.dart';

/// An agent that can do exactly what it is handed.
class FakeDeviceAgent implements DeviceAgent {
  FakeDeviceAgent({
    this.textureId = const NativeTextureId(1),
    DeviceScreenSize screenSize = const DeviceScreenSize(
      width: 1080,
      height: 2400,
    ),
    this.audio,
    this.clipboard,
    this.screenCapture,
    this.interaction,
    this.fileTransfer,
  }) : screenSizes = BehaviorSubject.seeded(screenSize);

  final BehaviorSubject<DeviceScreenSize> screenSizes;
  var isDisposed = false;

  @override
  final NativeTextureId textureId;

  @override
  final AudioDeviceAgent? audio;

  @override
  final ClipboardDeviceAgent? clipboard;

  @override
  final ScreenCaptureDeviceAgent? screenCapture;

  @override
  final InteractionDeviceAgent? interaction;

  @override
  final FileTransferDeviceAgent? fileTransfer;

  @override
  DeviceScreenSize get screenSize => screenSizes.value;

  @override
  Stream<DeviceScreenSize> get screenSizeChanges => screenSizes.stream;

  @override
  Future<void> dispose() async {
    isDisposed = true;
    await screenSizes.close();
  }
}
