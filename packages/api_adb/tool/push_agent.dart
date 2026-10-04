import 'dart:convert';

import 'package:api_adb/api_adb.dart';

Future<void> main(List<String> arguments) async {
  final serialNumber = arguments.first;
  final api = AdbApi(adbPath: 'adb');
  final connection = api.connect(serialNumber);

  await connection.pushFile(
    localFilepath: '../../device_agent/agent/build/dex/classes.dex',
    remoteFilepath: '/data/local/tmp/device_agent.dex',
  );

  print(
    'Pushed classes.dex to /data/local/tmp/device_agent.dex on $serialNumber',
  );

  await Future.delayed(const .new(seconds: 2));

  final process = await connection.startShell([
    'CLASSPATH=/data/local/tmp/device_agent.dex',
    'app_process',
    '/system/bin',
    'de.synk.MainKt',
  ]);

  process.stdout.transform(utf8.decoder).listen(print);
  process.stderr.transform(utf8.decoder).listen(print);

  await Future.delayed(const .new(seconds: 2));
}
