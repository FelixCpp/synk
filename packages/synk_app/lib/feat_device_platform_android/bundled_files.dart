import 'package:file/file.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

/// Puts files that ship inside the app bundle onto disk, where `adb push` can
/// read them.
///
/// Each file is written once per run. Concurrent callers share that one
/// write instead of racing each other into the same path.
class BundledFiles({
  required final AssetBundle bundle,
  required final FileSystem fileSystem,
  required final String directory,
}) {
  final _extracted = <String, Future<String>>{};

  /// The path of [asset] on disk, written there as [filename] on first use.
  Future<String> pathOf(String asset, {required String filename}) {
    return _extracted[asset] ??= _extract(asset, filename);
  }

  Future<String> _extract(String asset, String filename) async {
    final data = await bundle.load(asset);
    final file = await fileSystem
        .file(path.join(directory, filename))
        .create(recursive: true);

    await file.writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );

    return file.path;
  }
}
