import 'dart:io';
import 'dart:typed_data';

import 'package:api_adb/adb/process/adb_device_communicator.dart';

class const AndroidScreenTransmission({
  required final Socket socket,
  required final Stream<Uint8List> byteStream,
  required final Process process,
  required final AdbPortForward portForward,
}) {
  Future<void> dispose() async {
    await socket.close();
    await portForward.dispose();
    process.kill();
  }
}
