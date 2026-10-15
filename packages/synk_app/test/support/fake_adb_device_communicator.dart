import 'package:api_adb/api_adb.dart';

import 'fake_process_manager.dart';

/// A device that runs [process] for every shell it is asked to start, and
/// hands out [portForward] for every forward. Without one, forwarding fails
/// the way it does for a device that went away.
class FakeAdbDeviceCommunicator implements AdbDeviceCommunicator {
  FakeAdbDeviceCommunicator({required this.process, this.portForward});

  final FakeProcess process;
  final AdbPortForward? portForward;

  final pushes = <({String localFilepath, String remoteFilepath})>[];
  final startedShells = <List<String>>[];

  @override
  Future<void> pushFile({
    required String localFilepath,
    required String remoteFilepath,
  }) async {
    pushes.add((localFilepath: localFilepath, remoteFilepath: remoteFilepath));
  }

  @override
  Future<FakeProcess> startShell(List<String> arguments) async {
    startedShells.add(arguments);
    return process;
  }

  @override
  Future<AdbPortForward> forward({required int remotePort, int? localPort}) {
    return _forward();
  }

  @override
  Future<AdbPortForward> forwardAbstract({
    required String remoteSocketName,
    int? localPort,
  }) {
    return _forward();
  }

  Future<AdbPortForward> _forward() async {
    return portForward ??
        (throw const AdbCommandException(message: 'adb forward failed'));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
