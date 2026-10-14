class const MirrorOptions({
  required final int maxFps,
  required final int videoBitRate,
  required final bool turnDeviceScreenOff,
}) {
  const MirrorOptions.defaults()
    : this(
        maxFps: 60,
        videoBitRate: 8000000,
        turnDeviceScreenOff: false,
      );
}
