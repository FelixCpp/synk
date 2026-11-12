import 'dart:io' show ProcessException;

import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_version/data/app_bundle_installer.dart';

import '../support/fake_process_manager.dart';

const _bundlePath = '/Applications/synk.app';
const _diskImagePath = '/downloads/synk-macos-v0.2.0.dmg';

void main() {
  late MemoryFileSystem fileSystem;
  late FakeProcessManager processManager;

  FakeCommandResult fakeMacOS(
    List<String> command, {
    bool isWritable = true,
    String appInImage = 'synk.app',
  }) {
    switch (command) {
      case ['test', '-w', ...]:
        return (exitCode: isWritable ? 0 : 1, stdout: '', stderr: '');
      case ['hdiutil', 'attach', ...]:
        final mountPoint = command[command.indexOf('-mountpoint') + 1];
        fileSystem.file('$mountPoint/$appInImage/Contents/version')
          ..createSync(recursive: true)
          ..writeAsStringSync('new');
      case ['ditto', final from, final to]:
        fileSystem.file('$to/Contents/version')
          ..createSync(recursive: true)
          ..writeAsStringSync(
            fileSystem.file('$from/Contents/version').readAsStringSync(),
          );
    }

    return fakeSuccess;
  }

  AppBundleInstaller installer({
    String bundlePath = _bundlePath,
    bool isWritable = true,
    String appInImage = 'synk.app',
  }) {
    processManager = FakeProcessManager(
      respond: (command) => fakeMacOS(
        command,
        isWritable: isWritable,
        appInImage: appInImage,
      ),
    );

    return AppBundleInstaller(
      processManager: processManager,
      fileSystem: fileSystem,
      bundlePath: bundlePath,
    );
  }

  setUp(() {
    fileSystem = MemoryFileSystem();
    fileSystem.file('$_bundlePath/Contents/version')
      ..createSync(recursive: true)
      ..writeAsStringSync('old');
    fileSystem.systemTempDirectory.createSync(recursive: true);
  });

  group('canReplaceBundle', () {
    test('is true for a bundle in a writable folder', () async {
      expect(await installer().canReplaceBundle(), isTrue);
      expect(processManager.commands, [
        ['test', '-w', '/Applications'],
      ]);
    });

    test('is false for a bundle in a read-only folder', () async {
      expect(await installer(isWritable: false).canReplaceBundle(), isFalse);
    });

    test('is false while Synk runs from a disk image', () async {
      final result = await installer(
        bundlePath: '/Volumes/synk/synk.app',
      ).canReplaceBundle();

      expect(result, isFalse);
    });

    test('is false while macOS runs Synk from a translocated copy', () async {
      final result = await installer(
        bundlePath: '/private/var/folders/x/AppTranslocation/ABC/d/synk.app',
      ).canReplaceBundle();

      expect(result, isFalse);
    });
  });

  group('install', () {
    test('replaces the bundle with the app from the disk image', () async {
      await installer().install(_diskImagePath);

      expect(
        fileSystem.file('$_bundlePath/Contents/version').readAsStringSync(),
        'new',
      );
      expect(
        fileSystem.directory('/Applications').listSync().map((e) => e.path),
        [
          _bundlePath,
        ],
      );
    });

    test('detaches the disk image again', () async {
      await installer().install(_diskImagePath);

      final attach = processManager.commands.first;
      final mountPoint = attach[attach.indexOf('-mountpoint') + 1];

      expect(processManager.commands.last, [
        'hdiutil',
        'detach',
        mountPoint,
        '-force',
      ]);
      expect(fileSystem.directory(mountPoint).existsSync(), isFalse);
    });

    test('finds the app under whatever name the image gives it', () async {
      await installer(appInImage: 'Synk Beta.app').install(_diskImagePath);

      expect(
        fileSystem.file('$_bundlePath/Contents/version').readAsStringSync(),
        'new',
      );
    });

    test('keeps the old bundle when copying fails', () async {
      processManager = FakeProcessManager(
        respond: (command) => command.first == 'ditto'
            ? (exitCode: 1, stdout: '', stderr: 'disk full')
            : fakeMacOS(command),
      );

      final failing = AppBundleInstaller(
        processManager: processManager,
        fileSystem: fileSystem,
        bundlePath: _bundlePath,
      );

      await expectLater(
        failing.install(_diskImagePath),
        throwsA(isA<ProcessException>()),
      );
      expect(
        fileSystem.file('$_bundlePath/Contents/version').readAsStringSync(),
        'old',
      );
      expect(processManager.commands.last.take(2), ['hdiutil', 'detach']);
    });
  });

  test('relaunches the bundle once this process has exited', () async {
    await installer().relaunchAfterExit();

    expect(processManager.commands.single, [
      '/bin/sh',
      '-c',
      r'while kill -0 "$0" 2>/dev/null; do sleep 0.2; done; open "$1"',
      isA<String>(),
      _bundlePath,
    ]);
  });
}
