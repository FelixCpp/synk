/// The file the device is writing to while a recording runs.
class RunningRecording {
  String? _filepath;

  bool get isRunning => _filepath != null;

  void started(String filepath) {
    _filepath = filepath;
  }

  String? take() {
    final filepath = _filepath;
    _filepath = null;
    return filepath;
  }
}
