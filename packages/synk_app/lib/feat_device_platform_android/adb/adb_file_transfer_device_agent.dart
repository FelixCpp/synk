import 'package:api_adb/api_adb.dart';
import 'package:path/path.dart' as path;
import 'package:synk/feat_device_platform/application/agents/file_transfer_device_agent.dart';

const _androidDownloadsDirectory = '/sdcard/Download';

class const AdbFileTransferDeviceAgent(final AdbDeviceCommunicator communicator)
    implements FileTransferDeviceAgent {
  @override
  Future<void> installApk(String filepath) {
    return communicator.install(localFilepath: filepath);
  }

  @override
  Future<void> pushFile(String filepath) {
    return communicator.pushFile(
      localFilepath: filepath,
      remoteFilepath: '$_androidDownloadsDirectory/${path.basename(filepath)}',
    );
  }
}
