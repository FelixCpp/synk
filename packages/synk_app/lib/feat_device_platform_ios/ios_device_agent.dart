import 'dart:async';

import 'package:api_devicectl/api_devicectl.dart';
import 'package:app_logger/app_logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/application/agents/audio_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/clipboard_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/file_transfer_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/interaction_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/screen_capture_device_agent.dart';
import 'package:synk/feat_device_platform/application/device_agent.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/domain/models/native_texture_id.dart';
import 'package:synk/feat_device_platform_ios/devicectl/ios_clipboard_device_agent.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_hid_channel.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_interaction_device_agent.dart';
import 'package:synk/feat_device_platform_ios/ios_screen_capture_device_agent.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_audio_device_agent.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_transport.dart';
import 'package:synk/feat_device_platform/domain/models/device_id.dart';

class IosDeviceAgent({
  required final IosMirrorTransport transport,
  required final IosHidChannel hidChannel,
  required final DevicectlApi devicectl,
  required final DeviceId deviceId,
  @override required final NativeTextureId textureId,
  required DeviceScreenSize initialScreenSize,

  /// Whether the HID session behind [hidChannel] could be prepared. Without
  /// it the device is mirrored view-only.
  required bool supportsInteraction,
}) implements DeviceAgent {
  final IosInteractionDeviceAgent? _interaction = supportsInteraction
      ? IosInteractionDeviceAgent(
          hidChannel: hidChannel,
          deviceId: deviceId,
          screenSizeChanges: transport.screenSizeChanges(textureId),
        )
      : null;

  /// The capture session is silent; sound only exists where the CoreDevice
  /// audio stream could be started beside it.
  final IosAudioDeviceAgent? _audio = transport.supportsAudio
      ? IosAudioDeviceAgent(transport: transport, textureId: textureId)
      : null;

  final _screenCapture = IosScreenCaptureDeviceAgent(
    transport: transport,
    devicectl: devicectl,
    deviceId: deviceId,
    textureId: textureId,
  );

  final _screenSize = BehaviorSubject.seeded(initialScreenSize);
  late final IosClipboardDeviceAgent _clipboard;
  late final StreamSubscription<DeviceScreenSize> _screenSizeSubscription;

  this {
    _clipboard = IosClipboardDeviceAgent(
      devicectl: devicectl,
      deviceId: deviceId,
      interaction: _interaction,
    );
    _screenSizeSubscription = transport
        .screenSizeChanges(textureId)
        .listen(_screenSize.add);
  }

  @override
  DeviceScreenSize get screenSize => _screenSize.value;

  @override
  Stream<DeviceScreenSize> get screenSizeChanges => _screenSize.stream;

  @override
  AudioDeviceAgent? get audio => _audio;

  @override
  ClipboardDeviceAgent? get clipboard => _clipboard;

  @override
  InteractionDeviceAgent? get interaction => _interaction;

  @override
  ScreenCaptureDeviceAgent? get screenCapture => _screenCapture;

  @override
  FileTransferDeviceAgent? get fileTransfer => null;

  @override
  Future<void> dispose() async {
    await _interaction?.dispose();
    await _screenSizeSubscription.cancel();
    await _screenSize.close();

    try {
      await hidChannel.releaseInput(deviceId);
    } on Object catch (error, stackTrace) {
      appLogger.w(
        'Failed to release the touch input of $deviceId',
        error: error,
        stackTrace: stackTrace,
      );
    }

    await transport.stopMirror(textureId);
  }
}
