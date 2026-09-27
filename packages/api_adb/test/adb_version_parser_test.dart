import 'package:api_adb/adb/version/adb_version_parser.dart';
import 'package:test/test.dart';

void main() {
  test('parses a well-formed adb version string', () {
    final version = parseAdbVersionDto('1.0.41-12873539');

    expect(version.major, 1);
    expect(version.minor, 0);
    expect(version.patch, 41);
    expect(version.build, 12873539);
  });

  test('throws a FormatException for a malformed version string', () {
    expect(
      () => parseAdbVersionDto('not a version'),
      throwsA(isA<FormatException>()),
    );
  });

  test('throws a FormatException when the build suffix is missing', () {
    expect(
      () => parseAdbVersionDto('1.0.41'),
      throwsA(isA<FormatException>()),
    );
  });
}
