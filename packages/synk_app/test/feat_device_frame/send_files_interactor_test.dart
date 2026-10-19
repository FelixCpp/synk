import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_frame/domain/models/file_transfer_outcome.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';

import '../support/device_frame_harness.dart';

void main() {
  late _RecordingFileTransfer files;
  late DeviceFrameHarness harness;

  setUp(() {
    files = _RecordingFileTransfer();
    harness = DeviceFrameHarness(fileTransfer: files);
    addTearDown(harness.dispose);
  });

  test('installs an apk and pushes everything else', () async {
    final outcomes = await harness.device.sendFiles.getOrThrow([
      '/tmp/app.apk',
      '/tmp/notes.txt',
    ]);

    expect(files.installed, ['/tmp/app.apk']);
    expect(files.pushed, ['/tmp/notes.txt']);
    expect(outcomes.map((outcome) => outcome.action), [
      FileTransferAction.installed,
      FileTransferAction.pushed,
    ]);
  });

  test('reads the extension whatever its case', () async {
    await harness.device.sendFiles.getOrThrow(['/tmp/App.APK']);

    expect(files.installed, ['/tmp/App.APK']);
    expect(files.pushed, isEmpty);
  });

  test('names each outcome after the file, not after its path', () async {
    final outcomes = await harness.device.sendFiles.getOrThrow([
      '/a/deep/path/notes.txt',
    ]);

    expect(outcomes.single.filename, 'notes.txt');
  });

  test('keeps the order it was handed', () async {
    await harness.device.sendFiles.getOrThrow(['/1.txt', '/2.apk', '/3.txt']);

    expect(files.calls, ['push /1.txt', 'install /2.apk', 'push /3.txt']);
  });

  test('refuses a device that cannot take files at all', () {
    final viewOnly = DeviceFrameHarness();
    addTearDown(viewOnly.dispose);

    expect(
      viewOnly.device.sendFiles.getOrThrow(['/tmp/notes.txt']),
      throwsA(isA<Exception>()),
    );
  });
}

class _RecordingFileTransfer implements DeviceFileTransfer {
  final installed = <String>[];
  final pushed = <String>[];
  final calls = <String>[];

  @override
  Future<void> installApk(String filepath) async {
    installed.add(filepath);
    calls.add('install $filepath');
  }

  @override
  Future<void> pushFile(String filepath) async {
    pushed.add(filepath);
    calls.add('push $filepath');
  }
}
