import 'dart:async';

import 'package:api_devicectl/api_devicectl.dart';
import 'package:file/file.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/application/teardown.dart';
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
  required final FileSystem fileSystem,
  required final DeviceId deviceId,
  @override required final NativeTextureId textureId,
  required DeviceScreenSize initialScreenSize,
  @override
  required final InteractionUnavailableReason? interactionUnavailableReason,
}) implements DeviceSession {
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
    fileSystem: fileSystem,
  );

  final _screenSize = BehaviorSubject.seeded(initialScreenSize);
  late final IosInteraction? _interaction;
  late final IosClipboard _clipboard;
  late final StreamSubscription<DeviceScreenSize> _screenSizeSubscription;

  this {
    _interaction = interactionUnavailableReason == null
        ? IosInteraction(
            hidChannel: hidChannel,
            deviceId: deviceId,
            screenSize: _screenSize,
          )
        : null;
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
  DeviceTextInput? get textInput => null;

  @override
  DeviceInteraction? get interaction => _interaction;

  @override
  DeviceScreenCapture? get screenCapture => _screenCapture;

  @override
  DeviceFileTransfer? get fileTransfer => null;

  @override
  Future<void> dispose() {
    return tearDownEach('the session of $deviceId', [
      () => transport.stopMirror(textureId),
      () async => _interaction?.dispose(),
      _screenSizeSubscription.cancel,
      _screenSize.close,
      () => hidChannel.releaseInput(deviceId),
    ]);
  }
}
