import 'package:api_devicectl/api_devicectl.dart';
import 'package:app_logger/app_logger.dart';
import 'package:file/file.dart';
import 'package:rxdart/rxdart.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/camera_access_denied_exception.dart';
import 'package:synk/feat_device_platform/domain/models/device_setup_exception.dart';
import 'package:synk/feat_device_platform/domain/models/mirror_options.dart';
import 'package:synk/feat_device_platform/application/device_platform.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_device.dart';
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
  required final FileSystem fileSystem,
}) implements DevicePlatform {
  final Stream<List<PluggedDevice>> _devices;

  this
    : _devices = discoveryChannel
          .observeDevices()
          .map((dtos) => dtos.map((dto) => dto.toDomain()).toList())
          .shareValue();

  @override
  Set<ExternalTool> getRequiredTools() {
    return const {};
  }

  @override
  Stream<List<PluggedDevice>> observeDevices() {
    return _devices;
  }

  @override
  // iOS mirroring does not go through scrcpy, so [options] has nothing to
  // act on here.
  Future<DeviceSession> connect(DeviceId deviceId, MirrorOptions _) async {
    final IosMirrorStartResult result;
    try {
      result = await channel.startMirror(deviceId);
    } on CameraAccessDeniedException {
      rethrow;
    } on Object {
      final problem = await _diagnose(deviceId);
      if (problem != null) throw DeviceSetupException(problem: problem);
      rethrow;
    }

    final audio = await _startAudio(deviceId);
    appLogger.i(
      'Mirroring $deviceId over the capture session'
      '${audio == null ? ' without audio' : ' with audio'}',
    );

    return IosDeviceSession(
      transport: IosMirrorTransport(channel, audio),
      hidChannel: hidChannel,
      devicectl: devicectl,
      fileSystem: fileSystem,
      deviceId: deviceId,
      textureId: result.textureId,
      initialScreenSize: DeviceScreenSize(
        width: result.width,
        height: result.height,
      ),
      interactionUnavailableReason: await _prepareInput(deviceId),
    );
  }

  @override
  Future<void> dispose() async {}

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

  Future<InteractionUnavailableReason?> _prepareInput(
    DeviceId deviceId,
  ) async {
    final IosInputProblem? problem;
    try {
      problem = await hidChannel.prepareInput(deviceId);
    } on Object catch (error, stackTrace) {
      appLogger.w(
        'No touch input for $deviceId; mirroring it view-only',
        error: error,
        stackTrace: stackTrace,
      );

      return .unknown;
    }

    if (problem == null) {
      appLogger.i('Touch input ready for $deviceId');
      return null;
    }

    final reason = switch (problem) {
      .coreDeviceUnavailable =>
        InteractionUnavailableReason.coreDeviceUnavailable,
      .deviceUnknown || .preparationFailed => switch (await _diagnose(
        deviceId,
      )) {
        .notPaired => InteractionUnavailableReason.deviceNotPaired,
        .developerModeDisabled =>
          InteractionUnavailableReason.developerModeDisabled,
        .developerDiskImageUnavailable =>
          InteractionUnavailableReason.developerDiskImageUnavailable,
        null => InteractionUnavailableReason.unknown,
      },
    };

    appLogger.i(
      'No touch input for $deviceId ($reason); mirroring it view-only',
    );
    return reason;
  }

  Future<DeviceSetupProblem?> _diagnose(DeviceId deviceId) async {
    try {
      final status = await devicectl.deviceStatus(deviceId: deviceId);
      if (status == null || !status.isPaired) {
        return .notPaired;
      }

      if (status.isDeveloperModeEnabled == false) {
        return .developerModeDisabled;
      }

      if (status.isDeveloperDiskImageAvailable == false) {
        return .developerDiskImageUnavailable;
      }
    } on Object catch (error, stackTrace) {
      appLogger.w(
        'Could not tell what keeps $deviceId from working',
        error: error,
        stackTrace: stackTrace,
      );
    }

    return null;
  }
}
