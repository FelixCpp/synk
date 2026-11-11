import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_platform_android/adb/adb_file_transfer.dart';

import '../../support/fake_adb_device_communicator.dart';
import '../../support/fake_process_manager.dart';

void main() {
  late FakeAdbDeviceCommunicator communicator;
  late List<String> scanned;
  late AdbFileTransfer transfer;

  setUp(() {
    communicator = FakeAdbDeviceCommunicator(process: FakeProcess());
    scanned = [];
    transfer = AdbFileTransfer(communicator, scanFile: scanned.add);
  });

  test('pushes a file into the downloads of the device', () async {
    final destination = await transfer.pushFile('/Users/me/notes.pdf');

    expect(destination, '/sdcard/Download/notes.pdf');
    expect(communicator.pushes.single, (
      localFilepath: '/Users/me/notes.pdf',
      remoteFilepath: '/sdcard/Download/notes.pdf',
    ));
  });

  test('lets the media store know about the pushed file', () async {
    await transfer.pushFile('/Users/me/holiday.jpg');

    expect(scanned, ['/storage/emulated/0/Download/holiday.jpg']);
  });
}
