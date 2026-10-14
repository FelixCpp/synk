/// How many frames per second the mirror asks the device to encode.
enum MirrorFrameRate {
  fps30(maxFps: 30),
  fps60(maxFps: 60);

  const MirrorFrameRate({required this.maxFps});

  /// Value of scrcpy's `max_fps` server option.
  final int maxFps;
}
