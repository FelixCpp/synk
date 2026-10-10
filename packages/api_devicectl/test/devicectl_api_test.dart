import 'dart:io';

import 'package:api_devicectl/api_devicectl.dart';
import 'package:test/test.dart';

File _writeFakeXcrun(
  Directory directory, {
  required int exitCode,
  String stdout = '',
  String stderr = '',
  bool captureStdin = false,
}) {
  final argumentLog = File('${directory.path}/arguments.txt');
  final stdinLog = File('${directory.path}/stdin.txt');
  final script = File('${directory.path}/xcrun')
    ..writeAsStringSync('''
#!/bin/sh
printf '%s\\n' "\$@" > ${argumentLog.path}
${captureStdin ? 'cat > ${stdinLog.path}' : ''}
printf '%s' '$stdout'
printf '%s' '$stderr' >&2
exit $exitCode
''');

  Process.runSync('chmod', ['+x', script.path]);
  return script;
}

List<String> _loggedArguments(Directory directory) {
  return File('${directory.path}/arguments.txt')
      .readAsLinesSync()
      .where((line) => line.isNotEmpty)
      .toList();
}

String _loggedStdin(Directory directory) {
  return File('${directory.path}/stdin.txt').readAsStringSync();
}

void main() {
  late Directory directory;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('devicectl_api_test');
  });

  tearDown(() {
    directory.deleteSync(recursive: true);
  });

  group('captureScreenshot', () {
    test('invokes devicectl with the device and destination', () async {
      final script = _writeFakeXcrun(directory, exitCode: 0);
      final api = DevicectlApi(xcrunPath: script.path);

      await api.captureScreenshot(
        deviceId: '00008120-0009555001C2601E',
        destination: '/tmp/shot.png',
        timeout: const Duration(seconds: 12),
      );

      expect(_loggedArguments(directory), [
        'devicectl',
        'device',
        'capture',
        'screenshot',
        '--device',
        '00008120-0009555001C2601E',
        '--destination',
        '/tmp/shot.png',
        '--timeout',
        '12',
        '--quiet',
      ]);
    });

    test('throws with the process output when devicectl fails', () async {
      final script = _writeFakeXcrun(
        directory,
        exitCode: 1,
        stderr: 'ERROR: device not found',
      );
      final api = DevicectlApi(xcrunPath: script.path);

      await expectLater(
        api.captureScreenshot(
          deviceId: 'unknown-device',
          destination: '/tmp/shot.png',
        ),
        throwsA(
          isA<DevicectlCommandException>().having(
            (exception) => exception.toString(),
            'toString',
            allOf(contains('unknown-device'), contains('device not found')),
          ),
        ),
      );
    });
  });

  group('readPasteboard', () {
    test('returns the payload devicectl wrote to stdout', () async {
      final script = _writeFakeXcrun(
        directory,
        exitCode: 0,
        stdout: 'clipboard content',
      );
      final api = DevicectlApi(xcrunPath: script.path);

      final text = await api.readPasteboard(
        deviceId: 'some-device',
        timeout: const Duration(seconds: 9),
      );

      expect(text, 'clipboard content');
      expect(_loggedArguments(directory), [
        'devicectl',
        'device',
        'pasteboard',
        'paste',
        '--device',
        'some-device',
        '--timeout',
        '9',
        '--quiet',
      ]);
    });

    test('treats an empty pasteboard as empty text, not a failure', () async {
      final script = _writeFakeXcrun(directory, exitCode: 0);
      final api = DevicectlApi(xcrunPath: script.path);

      expect(await api.readPasteboard(deviceId: 'some-device'), isEmpty);
    });

    test(
      'reports the error message rather than the raw stdout bytes',
      () async {
        final script = _writeFakeXcrun(
          directory,
          exitCode: 1,
          stderr: 'ERROR: pasteboard unavailable',
        );
        final api = DevicectlApi(xcrunPath: script.path);

        await expectLater(
          api.readPasteboard(deviceId: 'some-device'),
          throwsA(
            isA<DevicectlCommandException>().having(
              (exception) => exception.toString(),
              'toString',
              allOf(
                contains('pasteboard unavailable'),
                isNot(contains('[')),
              ),
            ),
          ),
        );
      },
    );
  });

  group('writePasteboard', () {
    test('feeds the text to devicectl on stdin', () async {
      final script = _writeFakeXcrun(
        directory,
        exitCode: 0,
        captureStdin: true,
      );
      final api = DevicectlApi(xcrunPath: script.path);

      await api.writePasteboard(
        deviceId: 'some-device',
        text: 'hello from the host',
        timeout: const Duration(seconds: 9),
      );

      expect(_loggedStdin(directory), 'hello from the host');
      expect(_loggedArguments(directory), [
        'devicectl',
        'device',
        'pasteboard',
        'copy',
        '--device',
        'some-device',
        '--timeout',
        '9',
        '--quiet',
      ]);
    });

    test('throws when devicectl rejects the write', () async {
      final script = _writeFakeXcrun(
        directory,
        exitCode: 1,
        stderr: 'ERROR: device not found',
      );
      final api = DevicectlApi(xcrunPath: script.path);

      await expectLater(
        api.writePasteboard(deviceId: 'unknown-device', text: 'nope'),
        throwsA(isA<DevicectlCommandException>()),
      );
    });
  });
}
