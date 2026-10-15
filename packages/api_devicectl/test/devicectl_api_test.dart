import 'package:api_devicectl/api_devicectl.dart';
import 'package:test/test.dart';

import 'fake_process_manager.dart';

void main() {
  late FakeProcessManager processManager;

  DevicectlApi apiAnswering([FakeCommandResult result = fakeSuccess]) {
    processManager = FakeProcessManager(respond: (_) => result);
    return DevicectlApi(processManager: processManager);
  }

  group('captureScreenshot', () {
    test('invokes devicectl with the device and destination', () async {
      final api = apiAnswering();

      await api.captureScreenshot(
        deviceId: '00008120-0009555001C2601E',
        destination: '/tmp/shot.png',
        timeout: const Duration(seconds: 12),
      );

      expect(processManager.commands.single, [
        defaultXcrunPath,
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

    test(
      'inserts the dash IOKit omits from a compact 24-char UDID',
      () async {
        final api = apiAnswering();

        await api.captureScreenshot(
          deviceId: '000081200009555001C2601E',
          destination: '/tmp/shot.png',
        );

        expect(
          processManager.commands.single,
          containsAllInOrder(['--device', '00008120-0009555001C2601E']),
        );
      },
    );

    test(
      'leaves identifiers that are not a compact UDID untouched',
      () async {
        final api = apiAnswering();

        await api.captureScreenshot(
          deviceId: 'some-device',
          destination: '/tmp/shot.png',
        );

        expect(
          processManager.commands.single,
          containsAllInOrder(['--device', 'some-device']),
        );
      },
    );

    test('throws with the process output when devicectl fails', () async {
      final api = apiAnswering((
        exitCode: 1,
        stdout: '',
        stderr: 'ERROR: device not found',
      ));

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
      final api = apiAnswering((
        exitCode: 0,
        stdout: 'clipboard content',
        stderr: '',
      ));

      final text = await api.readPasteboard(
        deviceId: 'some-device',
        timeout: const Duration(seconds: 9),
      );

      expect(text, 'clipboard content');
      expect(processManager.commands.single, [
        defaultXcrunPath,
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
      final api = apiAnswering();

      expect(await api.readPasteboard(deviceId: 'some-device'), isEmpty);
    });

    test(
      'reports the error message rather than the raw stdout bytes',
      () async {
        final api = apiAnswering((
          exitCode: 1,
          stdout: '',
          stderr: 'ERROR: pasteboard unavailable',
        ));

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
      final api = apiAnswering();

      await api.writePasteboard(
        deviceId: 'some-device',
        text: 'hello from the host',
        timeout: const Duration(seconds: 9),
      );

      expect(processManager.stdinWrites, ['hello from the host']);
      expect(processManager.commands.single, [
        defaultXcrunPath,
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
      final api = apiAnswering((
        exitCode: 1,
        stdout: '',
        stderr: 'ERROR: device not found',
      ));

      await expectLater(
        api.writePasteboard(deviceId: 'unknown-device', text: 'nope'),
        throwsA(isA<DevicectlCommandException>()),
      );
    });
  });
}
