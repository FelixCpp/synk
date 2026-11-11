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

  test('selects the file in the Finder on macOS', () async {
    await openerOn(NativePlatform.macOS).reveal('/captures/shot.png');

    expect(processManager.commands, [
      ['open', '-R', '/captures/shot.png'],
    ]);
  });

  test('opens the folder of the file on Windows', () async {
    await openerOn(NativePlatform.windows).reveal(r'C:\captures\shot.png');

    expect(processManager.commands, [
      ['cmd', '/c', 'start', '', r'C:\captures'],
    ]);
  });

  test('opens the folder of the file on Linux', () async {
    await openerOn(NativePlatform.linux).reveal('/captures/shot.png');

    expect(processManager.commands, [
      ['xdg-open', '/captures'],
    ]);
  });

  test('moves the file to the trash on macOS', () async {
    await openerOn(NativePlatform.macOS).moveToTrash('/captures/shot.png');

    expect(processManager.commands, [
      ['trash', '/captures/shot.png'],
    ]);
  });

  test('moves the file to the trash through gio on Linux', () async {
    await openerOn(NativePlatform.linux).moveToTrash('/captures/shot.png');

    expect(processManager.commands, [
      ['gio', 'trash', '/captures/shot.png'],
    ]);
  });

  test('refuses to trash a file where it knows no trash', () async {
    await expectLater(
      openerOn(NativePlatform.windows).moveToTrash(r'C:\captures\shot.png'),
      throwsUnsupportedError,
    );
    expect(processManager.commands, isEmpty);
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
