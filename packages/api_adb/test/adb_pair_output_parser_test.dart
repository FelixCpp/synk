import 'package:api_adb/adb/pairing/adb_pair_output_parser.dart';
import 'package:test/test.dart';

void main() {
  test(
    'reads the service name the device advertises its connect port under',
    () {
      final result = parseAdbPairResult(
        exitCode: 0,
        output:
            'Successfully paired to 192.168.0.79:36479 '
            '[guid=adb-18131FDF6002UE-Vv70Va]\n',
      );

      expect(result.success, isTrue);
      expect(result.serviceName, 'adb-18131FDF6002UE-Vv70Va');
    },
  );

  test('pairs without a service name when adb does not print one', () {
    final result = parseAdbPairResult(
      exitCode: 0,
      output: 'Successfully paired to 192.168.0.79:36479\n',
    );

    expect(result.success, isTrue);
    expect(result.serviceName, isNull);
  });

  test('fails on a protocol fault even though adb exits cleanly', () {
    final result = parseAdbPairResult(
      exitCode: 0,
      output: 'error: protocol fault (couldn\'t read status message)\n',
    );

    expect(result.success, isFalse);
    expect(result.serviceName, isNull);
    expect(result.message, startsWith('error: protocol fault'));
  });

  test('fails on a non-zero exit code', () {
    final result = parseAdbPairResult(
      exitCode: 1,
      output: 'Failed: Wrong password or connection was dropped.\n',
    );

    expect(result.success, isFalse);
  });
}
