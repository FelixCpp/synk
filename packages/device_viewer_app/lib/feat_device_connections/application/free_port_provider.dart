import 'dart:io';

/// Reserves a currently-unused local TCP port by briefly binding to port 0
/// (the OS picks a free one) and releasing it immediately. There's a small
/// window where another process could grab the same port before the
/// subsequent `adb forward` binds it, but that's an acceptable risk for a
/// local desktop dev tool - not worth a heavier reservation scheme.
Future<int> reserveFreeLocalPort() async {
  final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
  final port = socket.port;
  await socket.close();
  return port;
}
