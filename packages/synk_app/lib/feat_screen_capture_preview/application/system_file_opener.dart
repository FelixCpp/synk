import 'dart:io' show ProcessException;

import 'package:path/path.dart' as path;
import 'package:platform/platform.dart';
import 'package:process/process.dart';

class const SystemFileOpener({
  required final ProcessManager processManager,
  required final NativePlatform platform,
}) {
  Future<void> open(String filepath) async {
    return _run(switch (platform.operatingSystem) {
      'macos' => ('open', [filepath]),
      'windows' => ('cmd', ['/c', 'start', '', filepath]),
      'linux' => ('xdg-open', [filepath]),
      final platform => throw UnsupportedError(
        'Cannot open $filepath on $platform',
      ),
    });
  }

  Future<void> reveal(String filepath) async {
    return _run(switch (platform.operatingSystem) {
      'macos' => ('open', ['-R', filepath]),
      'windows' => ('cmd', ['/c', 'start', '', path.windows.dirname(filepath)]),
      'linux' => ('xdg-open', [path.posix.dirname(filepath)]),
      final platform => throw UnsupportedError(
        'Cannot reveal $filepath on $platform',
      ),
    });
  }

  Future<void> moveToTrash(String filepath) async {
    return _run(switch (platform.operatingSystem) {
      'macos' => ('trash', [filepath]),
      'linux' => ('gio', ['trash', filepath]),
      final platform => throw UnsupportedError(
        'Cannot move $filepath to the trash on $platform',
      ),
    });
  }

  Future<void> _run((String, List<String>) command) async {
    final (executable, arguments) = command;
    final result = await processManager.run([executable, ...arguments]);

    if (result.exitCode != 0) {
      throw ProcessException(
        executable,
        arguments,
        result.stderr.toString().trim(),
        result.exitCode,
      );
    }
  }
}
