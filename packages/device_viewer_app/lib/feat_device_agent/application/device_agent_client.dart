import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';

import 'package:device_viewer/feat_device_agent/generated/device_agent.pb.dart';

class DeviceAgentClient({
  required final Socket socket,
}) {
  late final bytes = StreamQueue(socket.expand((chunk) => chunk));

  Future<GetInfoResponse> getInfo() async {
    final requestPayload = GetInfoRequest().writeToBuffer();
    final header = ByteData(4)..setUint32(0, requestPayload.length, Endian.big);

    // Send request
    socket.add(header.buffer.asUint8List());
    socket.add(requestPayload);

    // Receive response
    final lengthBytes = await bytes.take(4);
    final length = ByteData.sublistView(Uint8List.fromList(lengthBytes))
        .getUint32(0, Endian.big);
    final responsePayload = await bytes.take(length);
    return GetInfoResponse.fromBuffer(responsePayload);
  }

  Future<void> dispose() {
    return socket.close();
  }
}
