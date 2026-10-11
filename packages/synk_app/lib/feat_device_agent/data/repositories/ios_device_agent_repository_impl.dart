import 'package:api_devicectl/api_devicectl.dart';
import 'package:app_logger/app_logger.dart';
import 'package:synk/feat_device_agent/application/ios_device_agent.dart';
import 'package:synk/feat_device_agent/data/datasources/ios_hid_channel.dart';
import 'package:synk/feat_device_agent/data/datasources/ios_media_stream_channel.dart';
import 'package:synk/feat_device_agent/data/datasources/ios_mirror_channel.dart';
import 'package:synk/feat_device_agent/data/datasources/ios_mirror_transport.dart';
import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_agent/domain/repositories/device_agent_repository.dart';
import 'package:synk/feat_device_agent/domain/repositories/ios_device_agent_repository.dart';
import 'package:synk/feat_mirror_session/mirror_session.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';

/// What a started transport ended up being.
typedef _StartedMirror = ({
  IosMirrorTransport transport,
  NativeTextureIdAndSize result,
});

typedef NativeTextureIdAndSize = ({
  NativeTextureId textureId,
  DeviceScreenSize size,
});

class IosDeviceAgentRepositoryImpl(
  final IosMirrorChannel channel,
  final IosMediaStreamChannel mediaStreamChannel,
  final IosHidChannel hidChannel,
  final DevicectlApi devicectl,
) implements IosDeviceAgentRepository {
  final runningAgents = <DeviceId, IosDeviceAgent>{};

  @override
  Future<void> dispose() async {
    for (final agent in runningAgents.values) {
      await agent.dispose();
    }

    runningAgents.clear();
  }

  @override
  Future<IosDeviceAgent> establishConnection(DeviceId deviceId) async {
    if (runningAgents.containsKey(deviceId)) {
      throw DeviceAgentAlreadyConnectedException(deviceId: deviceId);
    }

    final mirror = await _startMirror(deviceId);
    final supportsInteraction = await _prepareInput(deviceId);

    final agent = IosDeviceAgent(
      mirror.transport,
      hidChannel,
      devicectl,
      deviceId,
      mirror.result.textureId,
      mirror.result.size,
      supportsInteraction,
    );

    runningAgents[deviceId] = agent;
    return agent;
  }

  /// Takes the picture from the AVFoundation capture session and the sound
  /// from a CoreDevice audio stream beside it.
  ///
  /// The media stream can carry the picture as well, and over Wi-Fi, but it
  /// drifts into a corrupt image within seconds and never recovers; only its
  /// audio is sound. Mirroring is therefore USB-only, and a device that will
  /// not hand over audio is still mirrored — silently.
  Future<_StartedMirror> _startMirror(DeviceId deviceId) async {
    final result = await channel.startMirror(deviceId);
    final audio = await _startAudio(deviceId);
    appLogger.i(
      'Mirroring $deviceId over the capture session'
      '${audio == null ? ' without audio' : ' with audio'}',
    );

    return (
      transport: IosCaptureSessionTransport(channel, audio),
      result: (
        textureId: result.textureId,
        size: DeviceScreenSize(width: result.width, height: result.height),
      ),
    );
  }

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

  @override
  Future<void> cutConnection(DeviceId deviceId) async {
    final agent = runningAgents.remove(deviceId);
    if (agent == null) {
      throw DeviceAgentNotConnectedException(deviceId: deviceId);
    }

    await agent.dispose();
  }
}
