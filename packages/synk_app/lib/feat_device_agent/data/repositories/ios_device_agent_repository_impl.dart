import 'package:api_devicectl/api_devicectl.dart';
import 'package:app_logger/app_logger.dart';
import 'package:synk/feat_device_agent/application/ios_device_agent.dart';
import 'package:synk/feat_device_agent/data/datasources/ios_hid_channel.dart';
import 'package:synk/feat_device_agent/data/datasources/ios_mirror_channel.dart';
import 'package:synk/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_agent/domain/repositories/device_agent_repository.dart';
import 'package:synk/feat_device_agent/domain/repositories/ios_device_agent_repository.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';

class IosDeviceAgentRepositoryImpl(
  final IosMirrorChannel channel,
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

    final result = await channel.startMirror(deviceId);

    final supportsInteraction = await _prepareInput(deviceId);

    final agent = IosDeviceAgent(
      channel,
      hidChannel,
      devicectl,
      deviceId,
      result.textureId,
      DeviceScreenSize(width: result.width, height: result.height),
      supportsInteraction,
    );

    runningAgents[deviceId] = agent;
    return agent;
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
