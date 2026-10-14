enum MirrorFrameRate {
  fps30(maxFps: 30),
  fps60(maxFps: 60);

  const MirrorFrameRate({required this.maxFps});

  final int maxFps;
}
