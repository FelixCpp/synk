import 'package:intl/intl.dart';

enum ScreenCaptureKind {
  screenshot(label: 'Screenshot', extension: 'png'),
  recording(label: 'Recording', extension: 'mp4');

  const ScreenCaptureKind({required this.label, required this.extension});

  static final _timestampFormat = DateFormat("yyyy-MM-dd 'at' HH.mm.ss");

  final String label;
  final String extension;

  String filenameFor(String modelName, DateTime takenAt) {
    return '$label $modelName ${_timestampFormat.format(takenAt)}.$extension';
  }
}
