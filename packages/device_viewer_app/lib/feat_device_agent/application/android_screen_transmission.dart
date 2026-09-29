import 'dart:io';
import 'dart:typed_data';

import 'package:api_adb/adb/process/adb_device_communicator.dart';
import 'package:device_viewer/feat_native_texture/native_texture.dart';

class const AndroidScreenTransmission({
  required final Socket socket,
  required final Stream<Uint8List> byteStream,
  required final Process process,
  required final AdbPortForward portForward,
  required final NativeTexture texture,
}) {
  Future<void> dispose() async {
    await socket.close();
    await portForward.dispose();
    await texture.dispose();
    process.kill();
  }
}
