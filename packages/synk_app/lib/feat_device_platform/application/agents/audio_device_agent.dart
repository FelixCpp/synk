abstract interface class AudioDeviceAgent {
  Future<void> setAudioMuted(bool muted);
  bool get isAudioMuted;
}
