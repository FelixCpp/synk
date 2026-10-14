/// What a platform should ask of a device when a session is established.
///
/// These are read once per connect: a running session keeps the values it was
/// started with, so changing them takes effect on the next connection.
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
