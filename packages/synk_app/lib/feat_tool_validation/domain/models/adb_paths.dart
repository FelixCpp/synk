class const AdbPaths({
  required final String bundled,
  final String? custom,
}) {
  String get active => custom ?? bundled;
}
