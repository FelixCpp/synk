abstract interface class AudioAgent {
  bool get isAudioMuted;
  Future<void> setAudioMuted(bool muted);
}
