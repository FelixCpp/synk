import 'package:api_adb/api_adb.dart';
import 'package:synk/feat_device_pairing/data/bonjour_channel.dart';
import 'package:synk/feat_device_pairing/domain/models/device_pairing_exception.dart';
import 'package:synk/feat_device_pairing/domain/models/pairing_outcome.dart';
import 'package:synk/feat_device_pairing/domain/models/wireless_connect_exception.dart';
import 'package:synk/feat_device_pairing/domain/repositories/device_pairing_repository.dart';

const _connectServiceType = '_adb-tls-connect._tcp';

class const DevicePairingRepositoryImpl({
  required final AdbApi api,
  required final BonjourChannel bonjour,
}) implements DevicePairingRepository {
  @override
  Future<PairingOutcome> pair(String hostPort, String code) async {
    final result = await api.pair(hostPort: hostPort, pairingCode: code);
    if (!result.success) {
      throw DevicePairingException(detail: result.message);
    }

    final serviceName = result.serviceName;
    if (serviceName == null) {
      return const PairingOutcome.connectPortUnknown();
    }

    if (await _connectToService(serviceName)) {
      return const PairingOutcome.connected();
    }

    final port = await bonjour.resolvePort(
      type: _connectServiceType,
      name: serviceName,
    );

    return port == null
        ? const PairingOutcome.connectPortUnknown()
        : PairingOutcome.connectPortResolved(port);
  }

  @override
  Future<void> connect(String hostPort) async {
    try {
      await api.connectWirelessly(hostPort);
    } on AdbCommandException catch (error) {
      throw WirelessConnectException(detail: error.message);
    }
  }

  Future<bool> _connectToService(String serviceName) async {
    for (var attempt = 0; attempt < 3; attempt++) {
      if (attempt > 0) {
        await Future<void>.delayed(const Duration(seconds: 1));
      }

      try {
        await api.connectWirelessly('$serviceName.$_connectServiceType');
        return true;
      } on AdbCommandException {
        continue;
      }
    }

    return false;
  }
}
