import 'dart:io' show ProcessException, ProcessStartMode, pid;

import 'package:file/file.dart';
import 'package:path/path.dart' as path;
import 'package:process/process.dart';

class const AppBundleInstaller({
  required final ProcessManager processManager,
  required final FileSystem fileSystem,
  required final String bundlePath,
}) {
  String get _stagedPath =>
      path.join(path.dirname(bundlePath), '.synk-update.app');
  String get _replacedPath =>
      path.join(path.dirname(bundlePath), '.synk-replaced.app');

  Future<bool> canReplaceBundle() async {
    if (path.extension(bundlePath) != '.app' ||
        path.isWithin('/Volumes', bundlePath) ||
        bundlePath.contains('/AppTranslocation/')) {
      return false;
    }

    final result = await processManager.run([
      'test',
      '-w',
      path.dirname(bundlePath),
    ]);

    return result.exitCode == 0;
  }

  Future<void> install(String diskImagePath) async {
    await _stage(diskImagePath);
    await _deleteIfExists(_replacedPath);
    await fileSystem.directory(bundlePath).rename(_replacedPath);

    try {
      await fileSystem.directory(_stagedPath).rename(bundlePath);
    } on Object {
      await fileSystem.directory(_replacedPath).rename(bundlePath);
      rethrow;
    }

    await _deleteIfExists(_replacedPath);
  }

  Future<void> relaunchAfterExit() async {
    await processManager.start(
      [
        '/bin/sh',
        '-c',
        r'while kill -0 "$0" 2>/dev/null; do sleep 0.2; done; open "$1"',
        '$pid',
        bundlePath,
      ],
      mode: ProcessStartMode.detached,
    );
  }

  Future<void> _stage(String diskImagePath) async {
    final mountPoint = await fileSystem.systemTempDirectory.createTemp(
      'synk-update',
    );

    await _run([
      'hdiutil',
      'attach',
      diskImagePath,
      '-nobrowse',
      '-readonly',
      '-noautoopen',
      '-mountpoint',
      mountPoint.path,
    ]);

    try {
      final app = mountPoint
          .listSync()
          .whereType<Directory>()
          .where((entity) => path.extension(entity.path) == '.app')
          .firstOrNull;

      if (app == null) {
        throw FileSystemException('No app in the disk image', diskImagePath);
      }

      await _deleteIfExists(_stagedPath);
      await _run(['ditto', app.path, _stagedPath]);
    } finally {
      await _run(['hdiutil', 'detach', mountPoint.path, '-force']);
      await _deleteIfExists(mountPoint.path);
    }
  }

  Future<void> _deleteIfExists(String directoryPath) async {
    final directory = fileSystem.directory(directoryPath);

    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  Future<void> _run(List<String> command) async {
    final result = await processManager.run(command);

    if (result.exitCode != 0) {
      throw ProcessException(
        command.first,
        command.skip(1).toList(),
        result.stderr.toString().trim(),
        result.exitCode,
      );
    }
  }
}
