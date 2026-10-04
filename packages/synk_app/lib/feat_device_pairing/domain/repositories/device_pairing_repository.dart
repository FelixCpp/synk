abstract interface class DevicePairingRepository {
  Future<void> pair(String hostPort, String code);
}
