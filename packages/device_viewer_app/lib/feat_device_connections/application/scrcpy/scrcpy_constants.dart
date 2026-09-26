/// Must exactly match the embedded `BuildConfig.VERSION_NAME` of the bundled
/// `assets/bundled_files/scrcpy-server.jar`, or the server aborts immediately
/// with a version-mismatch error. Update both together.
const scrcpyServerVersion = '4.1';

const scrcpyServerRemotePath = '/data/local/tmp/scrcpy-server.jar';

/// Prefix of the abstract Unix domain socket name scrcpy-server listens on.
/// With a `scid` passed, the server listens on `<prefix>_<scid as 8 lowercase
/// hex digits>` (`DesktopConnection.getSocketName`) instead of the bare
/// prefix - a random scid per session is required so a new session can never
/// attach to a still-listening (or not-yet-reaped) server left over from a
/// previous one, since a stale process holding the bare name would otherwise
/// make the *new* server fail to bind while an old, already-serviced one
/// silently swallows the new client's connection (no data ever arrives -
/// symptom: a permanently black mirror).
const scrcpySocketNamePrefix = 'scrcpy';
