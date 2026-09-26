import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Future<String> Function() getScrcpyServerFilepathProvider() {
  String? jarFilepath;

  return () async {
    if (jarFilepath case String jarPath) {
      return jarPath;
    }

    final jarFile = await rootBundle.load(
      'assets/bundled_files/scrcpy-server.jar',
    );
    final tempDir = await getTemporaryDirectory();
    final location = path.join(tempDir.path, 'scrcpy-server.jar');
    final file = await File(location).create(recursive: true);

    final bytes = jarFile.buffer.asUint8List(
      jarFile.offsetInBytes,
      jarFile.lengthInBytes,
    );

    await file.writeAsBytes(bytes);

    return jarFilepath = file.path;
  };
}
