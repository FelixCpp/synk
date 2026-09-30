import 'package:api_adb/api_adb.dart';
import 'package:device_viewer/feat_device_pairing/domain/repositories/device_pairing_repository.dart';

class const DevicePairingRepositoryImpl(final AdbApi api)
    implements DevicePairingRepository {
  @override
  Future<void> pair(String hostPort, String code) async {
    final result = await api.pair(hostPort: hostPort, pairingCode: code);
    if (!result.success) {
      throw Exception("Couldn't connect: ${result.message}");
    }

    await api.connectWirelessly(hostPort);
  }
}
