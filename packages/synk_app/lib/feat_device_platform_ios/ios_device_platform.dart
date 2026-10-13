import 'package:api_devicectl/api_devicectl.dart';
import 'package:app_logger/app_logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/application/device_platform.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_device_discovery_channel.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_hid_channel.dart';
import 'package:synk/feat_device_platform_ios/ios_device_session.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_media_stream_channel.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_channel.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_transport.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';

class IosDevicePlatform({
  required IosDeviceDiscoveryChannel discoveryChannel,
  required final IosMirrorChannel channel,
  required final IosMediaStreamChannel mediaStreamChannel,
  required final IosHidChannel hidChannel,
  required final DevicectlApi devicectl,
}) implements DevicePlatform {
  final Stream<List<PluggedDevice>> _devices;

  this
    : _devices = discoveryChannel.observeDevices().map<List<PluggedDevice>>((
        dtos,
      ) {
        return dtos.map((dto) => dto.toDomain()).toList();
      }).shareValue();

  /// Mirroring and input need no external tool. devicectl only backs the
  /// clipboard and the preferred screenshot path, and both degrade without it.
  @override
  Set<ExternalTool> getToolRequirements() {
    return const {};
  }

  @override
  Stream<List<PluggedDevice>> observeDevices() {
    return _devices;
  }

  @override
  Future<DeviceSession> connect(DeviceId deviceId) async {
    final result = await channel.startMirror(deviceId);
    final audio = await _startAudio(deviceId);
    appLogger.i(
      'Mirroring $deviceId over the capture session'
      '${audio == null ? ' without audio' : ' with audio'}',
    );

    return IosDeviceSession(
      transport: IosCaptureSessionTransport(channel, audio),
      hidChannel: hidChannel,
      devicectl: devicectl,
      deviceId: deviceId,
      textureId: result.textureId,
      initialScreenSize: DeviceScreenSize(
        width: result.width,
        height: result.height,
      ),
      supportsInteraction: await _prepareInput(deviceId),
    );
  }

  @override
  Future<void> dispose() async {}

  /// Audio needs CoreDevice, which needs Developer Mode and Xcode. Where that
  /// is missing the device is mirrored without sound rather than not at all.
  Future<IosAudioSideCar?> _startAudio(DeviceId deviceId) async {
    try {
      final sessionId = await mediaStreamChannel.startAudio(deviceId);
      return IosAudioSideCar(mediaStreamChannel, sessionId);
    } on Object catch (error, stackTrace) {
      appLogger.w(
        'No system audio for $deviceId; mirroring it silently',
        error: error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  Future<bool> _prepareInput(DeviceId deviceId) async {
    try {
      if (await hidChannel.prepareInput(deviceId)) {
        appLogger.i('Touch input ready for $deviceId');
        return true;
      }

      appLogger.i('No touch input for $deviceId; mirroring it view-only');
      return false;
    } on Object catch (error, stackTrace) {
      appLogger.w(
        'No touch input for $deviceId; mirroring it view-only',
        error: error,
        stackTrace: stackTrace,
      );

      return false;
    }
  }
}
