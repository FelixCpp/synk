import 'package:synk/feat_device_pairing/domain/models/pairable_device.dart';
import 'package:synk/feat_device_pairing/domain/models/pairing_outcome.dart';

abstract interface class DevicePairingRepository {
  Stream<List<PairableDevice>> observePairableDevices();

  Future<PairingOutcome> pair(String hostPort, String code);

  Future<void> connect(String hostPort);
}
