import 'dart:io';
import 'dart:typed_data';

class const AndroidAudioTransmission({
  required final Socket socket,
  required final Stream<Uint8List> byteStream,
}) {
  Future<void> dispose() async {
    await socket.close();
  }
}
