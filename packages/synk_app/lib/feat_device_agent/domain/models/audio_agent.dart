/// Forwarding of a device's audio to the host, where the platform offers it.
///
/// Android gets this from the scrcpy audio socket, iOS from a CoreDevice system
/// audio stream. Both start muted, so connecting a device never makes noise on
/// its own.
abstract interface class AudioAgent {
  /// False only while audio is actually reaching the host unmuted.
  bool get isAudioMuted;

  Future<void> setAudioMuted(bool muted);
}
