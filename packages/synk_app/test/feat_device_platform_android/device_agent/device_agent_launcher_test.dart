import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_platform_android/bundled_files.dart';
import 'package:synk/feat_device_platform_android/device_agent/device_agent_launcher.dart';

import '../../support/fake_adb_device_communicator.dart';
import '../../support/fake_asset_bundle.dart';
import '../../support/fake_process_manager.dart';

void main() {
  late DeviceAgentLauncher launcher;

  setUp(() {
    launcher = DeviceAgentLauncher(
      bundledFiles: BundledFiles(
        bundle: FakeAssetBundle({
          'assets/bundled_files/classes.dex': [1, 2, 3],
        }),
        fileSystem: MemoryFileSystem(),
        directory: '/cache',
      ),
    );
  });

  test('pushes the bundled agent and starts it from there', () async {
    final device = FakeAdbDeviceCommunicator(
      process: FakeProcess(stdout: 'Agent listening on port 27183\n'),
    );

    // Without a port forward the launch fails right after the agent is up,
    // which is all this test needs to get to.
    await expectLater(launcher.launch(device), throwsA(anything));

    expect(device.pushes.single, (
      localFilepath: '/cache/device_agent.dex',
      remoteFilepath: '/data/local/tmp/device_agent.dex',
    ));
    expect(device.startedShells.single, [
      'CLASSPATH=/data/local/tmp/device_agent.dex',
      'app_process',
      '/system/bin',
      DeviceAgentLauncher.mainClass,
    ]);
  });

  test('stops the agent when the port forward fails', () async {
    final process = FakeProcess(stdout: 'Agent listening on port 27183\n');
    final device = FakeAdbDeviceCommunicator(process: process);

    await expectLater(launcher.launch(device), throwsA(anything));

    expect(process.killed, isTrue);
  });

  test('reports an agent that exits before it listens', () async {
    final process = FakeProcess(stdout: 'Exception in thread "main"\n');
    final device = FakeAdbDeviceCommunicator(process: process);

    await expectLater(
      launcher.launch(device),
      throwsA(isA<DeviceAgentStartupException>()),
    );
    expect(process.killed, isTrue);
  });

  test('gives up on an agent that never starts listening', () async {
    final process = FakeProcess(keepsRunning: true);
    final device = FakeAdbDeviceCommunicator(process: process);

    await expectLater(
      launcher.launch(
        device,
        startupTimeout: const Duration(milliseconds: 10),
      ),
      throwsA(isA<DeviceAgentStartupException>()),
    );
    expect(process.killed, isTrue);
  });
}
