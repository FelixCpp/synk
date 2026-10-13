import 'dart:async';

import 'package:api_devicectl/api_devicectl.dart';
import 'package:app_logger/app_logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform_ios/devicectl/ios_clipboard.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_hid_channel.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_interaction.dart';
import 'package:synk/feat_device_platform_ios/ios_screen_capture.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_audio.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_transport.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';

class IosDeviceSession({
  required final IosMirrorTransport transport,
  required final IosHidChannel hidChannel,
  required final DevicectlApi devicectl,
  required final DeviceId deviceId,
  @override required final NativeTextureId textureId,
  required DeviceScreenSize initialScreenSize,

  /// Whether the HID session behind [hidChannel] could be prepared. Without
  /// it the device is mirrored view-only.
  required bool supportsInteraction,
}) implements DeviceSession {
  final IosInteraction? _interaction = supportsInteraction
      ? IosInteraction(
          hidChannel: hidChannel,
          deviceId: deviceId,
          screenSizeChanges: transport.screenSizeChanges(textureId),
        )
      : null;

  /// The capture session is silent; sound only exists where the CoreDevice
  /// audio stream could be started beside it.
  final IosAudio? _audio = transport.supportsAudio
      ? IosAudio(transport: transport, textureId: textureId)
      : null;

  final _screenCapture = IosScreenCapture(
    transport: transport,
    devicectl: devicectl,
    deviceId: deviceId,
    textureId: textureId,
  );

  final _screenSize = BehaviorSubject.seeded(initialScreenSize);
  late final IosClipboard _clipboard;
  late final StreamSubscription<DeviceScreenSize> _screenSizeSubscription;

  this {
    _clipboard = IosClipboard(
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
  DeviceAudio? get audio => _audio;

  @override
  DeviceClipboard? get clipboard => _clipboard;

  @override
  DeviceInteraction? get interaction => _interaction;

  @override
  DeviceScreenCapture? get screenCapture => _screenCapture;

  @override
  DeviceFileTransfer? get fileTransfer => null;

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
