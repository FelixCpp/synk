import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Future<String> Function() getDexFilepathProvider() {
  String? dexFilepath;

  return () async {
    if (dexFilepath case String dexPath) {
      return dexPath;
    }

    final dexFile = await rootBundle.load('assets/bundled_files/classes.dex');
    final tempDir = await getTemporaryDirectory();
    final location = path.join(tempDir.path, 'device_agent.dex');
    final file = await File(location).create(recursive: true);

    final bytes = dexFile.buffer.asUint8List(
      dexFile.offsetInBytes,
      dexFile.lengthInBytes,
    );

    await file.writeAsBytes(bytes);

    return dexFilepath = file.path;
  };
}
