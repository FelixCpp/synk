import 'dart:io' show ProcessException;

import 'package:platform/platform.dart';
import 'package:process/process.dart';

class const SystemFileOpener({
  required final ProcessManager processManager,
  required final NativePlatform platform,
}) {
  Future<void> open(String filepath) async {
    final (executable, arguments) = switch (platform.operatingSystem) {
      'macos' => ('open', [filepath]),
      'windows' => ('cmd', ['/c', 'start', '', filepath]),
      'linux' => ('xdg-open', [filepath]),
      final platform => throw UnsupportedError(
        'Cannot open $filepath on $platform',
      ),
    };

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
