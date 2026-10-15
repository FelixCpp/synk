import 'dart:io' show ProcessException;

import 'package:flutter_test/flutter_test.dart';
import 'package:platform/testing.dart';
import 'package:synk/feat_screen_capture_preview/application/system_file_opener.dart';

import '../support/fake_process_manager.dart';

void main() {
  late FakeProcessManager processManager;

  SystemFileOpener openerOn(
    String operatingSystem, [
    FakeCommandResult result = fakeSuccess,
  ]) {
    processManager = FakeProcessManager(respond: (_) => result);
    return SystemFileOpener(
      processManager: processManager,
      platform: TestNativePlatform(operatingSystem: operatingSystem),
    );
  }

  test('hands the file to open on macOS', () async {
    await openerOn(NativePlatform.macOS).open('/captures/shot.png');

    expect(processManager.commands, [
      ['open', '/captures/shot.png'],
    ]);
  });

  test('goes through start on Windows', () async {
    await openerOn(NativePlatform.windows).open(r'C:\captures\shot.png');

    expect(processManager.commands, [
      ['cmd', '/c', 'start', '', r'C:\captures\shot.png'],
    ]);
  });

  test('uses xdg-open on Linux', () async {
    await openerOn(NativePlatform.linux).open('/captures/shot.png');

    expect(processManager.commands, [
      ['xdg-open', '/captures/shot.png'],
    ]);
  });

  test('refuses a platform it has no opener for', () async {
    await expectLater(
      openerOn(NativePlatform.fuchsia).open('/captures/shot.png'),
      throwsUnsupportedError,
    );
    expect(processManager.commands, isEmpty);
  });

  test('reports what the opener printed when it fails', () async {
    final opener = openerOn(NativePlatform.macOS, (
      exitCode: 1,
      stdout: '',
      stderr: 'The file does not exist.\n',
    ));

    await expectLater(
      opener.open('/captures/gone.png'),
      throwsA(
        isA<ProcessException>()
            .having((error) => error.errorCode, 'errorCode', 1)
            .having(
              (error) => error.message,
              'message',
              'The file does not exist.',
            ),
      ),
    );
  });
}
