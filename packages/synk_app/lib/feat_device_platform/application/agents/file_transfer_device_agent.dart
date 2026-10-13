abstract interface class FileTransferDeviceAgent {
  Future<void> installApk(String filepath);
  Future<void> pushFile(String filepath);
}
