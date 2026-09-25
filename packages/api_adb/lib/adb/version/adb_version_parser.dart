import 'package:api_adb/adb/version/adb_version_dto.dart';

AdbVersionDto parseAdbVersionDto(String processOutput) {
  final expression = RegExp(r'^(\d+)\.(\d+)\.(\d+)-(\d+)$');
  final match = expression.firstMatch(processOutput);

  if (match == null) {
    throw FormatException('Invalid ARB version format');
  }

  final major = int.parse(match.group(1)!);
  final minor = int.parse(match.group(2)!);
  final patch = int.parse(match.group(3)!);
  final build = int.parse(match.group(4)!);

  return AdbVersionDto(
    major: major,
    minor: minor,
    patch: patch,
    build: build,
  );
}
