/// How much bandwidth the mirror's video stream is allowed to use.
///
/// Higher is sharper but costs throughput, which matters over a wireless adb
/// connection far more than over USB.
enum MirrorQuality {
  low(videoBitRate: 2000000),
  medium(videoBitRate: 8000000),
  high(videoBitRate: 16000000);

  const MirrorQuality({required this.videoBitRate});

  /// Value of scrcpy's `video_bit_rate` server option, in bits per second.
  final int videoBitRate;
}
