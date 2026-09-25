import 'dart:convert';
import 'dart:io';

import 'package:api_adb/api_adb.dart';
import 'package:device_viewer/feat_device_agent/application/device_agent_client.dart';

Future<void> main(List<String> arguments) async {
  final serialNumber = arguments.first;
  final api = AdbApi(adbPath: 'adb');
  final connection = api.connect(serialNumber);

  await connection.pushFile(
    localFilepath: '../device_agent/agent/build/dex/classes.dex',
    remoteFilepath: '/data/local/tmp/device_agent.dex',
  );

  final agentProcess = await connection.startShell([
    'CLASSPATH=/data/local/tmp/device_agent.dex',
    'app_process',
    '/system/bin',
    'de.deviceviewer.MainKt',
  ]);
  agentProcess.stdout.transform(utf8.decoder).listen(print);
  agentProcess.stderr.transform(utf8.decoder).listen(print);

  await Future.delayed(const .new(seconds: 1));

  final portForward = await connection.forward(
    localPort: 27183,
    remotePort: 27183,
  );

  final socket = await Socket.connect(
    InternetAddress.loopbackIPv4,
    portForward.localPort,
  );
  final client = DeviceAgentClient(socket: socket);

  final info = await client.fetchInfo();
  print(info);

  await client.dispose();
  await portForward.dispose();
  agentProcess.kill();
}
