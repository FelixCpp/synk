import 'dart:io';

class const DeviceAgentClient({
  required final Socket socket,
}) {
  // Future<DeviceInfo> getInfo() async {}

  Future<void> dispose() {
    return socket.close();
  }
}
