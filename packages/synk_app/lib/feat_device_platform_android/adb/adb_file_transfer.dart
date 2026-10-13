import 'package:api_adb/api_adb.dart';
import 'package:path/path.dart' as path;
import 'package:synk/feat_device_platform/application/device_session.dart';

const _androidDownloadsDirectory = '/sdcard/Download';

class const AdbFileTransfer(final AdbDeviceCommunicator communicator)
    implements DeviceFileTransfer {
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
