import 'package:synk/user_facing_exception.dart';

enum DeviceSetupProblem {
  notPaired,
  developerModeDisabled,
  developerDiskImageUnavailable,
}

class const DeviceSetupException({required final DeviceSetupProblem problem})
    implements UserFacingException {
  @override
  String toString() => switch (problem) {
    .notPaired =>
      'Das Gerät ist mit diesem Mac nicht gekoppelt. Gerät entsperren, '
          '„Diesem Computer vertrauen“ bestätigen und erneut verbinden.',
    .developerModeDisabled =>
      'Der Entwicklermodus ist aus. Auf dem Gerät unter Einstellungen › '
          'Datenschutz & Sicherheit › Entwicklermodus einschalten, das Gerät '
          'neu starten und erneut verbinden.',
    .developerDiskImageUnavailable =>
      'Das Gerät ist nicht für die Entwicklung vorbereitet. Gerät per Kabel '
          'anschließen, in Xcode unter Window › Devices and Simulators die '
          'Vorbereitung abwarten und erneut verbinden.',
  };
}
