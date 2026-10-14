enum MirrorQuality {
  low(videoBitRate: 2000000),
  medium(videoBitRate: 8000000),
  high(videoBitRate: 16000000);

  const MirrorQuality({required this.videoBitRate});
  final int videoBitRate;
}
