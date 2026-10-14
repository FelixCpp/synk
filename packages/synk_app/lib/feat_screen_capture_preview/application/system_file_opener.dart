import 'dart:io';

/// Hands a captured file to whatever application the operating system has
/// registered for it.
///
/// Synk shows no media of its own: the system viewers do it better, and they
/// are where the next step — annotating, trimming, attaching to a ticket —
/// happens anyway. A screen recording would otherwise drag a whole decoder
/// stack into the bundle for less than QuickTime already offers.
class const SystemFileOpener() {
  Future<void> open(String filepath) async {
    final (executable, arguments) = switch (Platform.operatingSystem) {
      'macos' => ('open', [filepath]),
      'windows' => ('cmd', ['/c', 'start', '', filepath]),
      'linux' => ('xdg-open', [filepath]),
      final platform => throw UnsupportedError(
        'Cannot open $filepath on $platform',
      ),
    };

    final result = await Process.run(executable, arguments);

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
