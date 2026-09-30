import 'package:device_viewer/feat_device_agent/application/ios_device_agent.dart';
import 'package:device_viewer/feat_device_agent/data/datasources/ios_mirror_channel.dart';
import 'package:device_viewer/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:device_viewer/feat_device_agent/domain/repositories/device_agent_repository.dart';
import 'package:device_viewer/feat_device_agent/domain/repositories/ios_device_agent_repository.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';

class IosDeviceAgentRepositoryImpl(final IosMirrorChannel channel)
    implements IosDeviceAgentRepository {
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

    final agent = IosDeviceAgent(
      channel,
      result.textureId,
      DeviceScreenSize(width: result.width, height: result.height),
    );

    runningAgents[deviceId] = agent;
    return agent;
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
