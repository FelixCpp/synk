import 'package:api_adb/api_adb.dart';
import 'package:path/path.dart' as path;
import 'package:synk/feat_device_platform/application/device_session.dart';

const _androidDownloadsDirectory = '/sdcard/Download';
const _androidSharedStorage = '/storage/emulated/0';

class const AdbFileTransfer(
  final AdbDeviceCommunicator communicator, {
  required final void Function(String remoteFilepath) scanFile,
}) implements DeviceFileTransfer {
  @override
  Future<void> installApk(String filepath) {
    return communicator.install(localFilepath: filepath);
  }

  @override
  Future<String> pushFile(String filepath) async {
    final filename = path.basename(filepath);
    final remoteFilepath = '$_androidDownloadsDirectory/$filename';

    await communicator.pushFile(
      localFilepath: filepath,
      remoteFilepath: remoteFilepath,
    );
    scanFile('$_androidSharedStorage/Download/$filename');

    return remoteFilepath;
  }
}
