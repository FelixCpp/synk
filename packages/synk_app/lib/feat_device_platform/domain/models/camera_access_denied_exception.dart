class const CameraAccessDeniedException() implements Exception {
  @override
  String toString() =>
      'Kein Kamerazugriff. Bitte in den Systemeinstellungen unter '
      'Datenschutz & Sicherheit › Kamera erlauben.';
}
