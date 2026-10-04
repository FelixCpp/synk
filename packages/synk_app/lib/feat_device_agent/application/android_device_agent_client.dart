import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:api_adb/api_adb.dart';
import 'package:async/async.dart';

import 'package:synk/feat_device_agent/generated/device_agent.pb.dart';

class const AdbAgentClientException({required final String message})
    implements Exception {
  @override
  String toString() => 'AdbAgentClientException: $message';
}

class AndroidDeviceAgentCommunicator({
  required final Socket socket,
  required final Process process,
  required final AdbPortForward portForward,
}) {
  final bytes = StreamQueue(socket.expand((chunk) => chunk));

  this {
    unawaited(
      socket.done.catchError((error, StackTrace stackTrace) {
        developer.log(
          'Agent socket closed with an error',
          name: 'AndroidDeviceAgentCommunicator',
          error: error,
          stackTrace: stackTrace,
        );
      }),
    );
  }

  Future<void> dispose() async {
    await socket.close();
    await portForward.dispose();
    process.kill();
  }

  Future<GetInfoResponse> fetchInfo() async {
    final response = await _sendToSocket(
      AgentRequest(getInfo: GetInfoRequest()),
    );

    if (response.whichPayload() == .error) {
      assert(response.hasError(), "Received Error object without being set.");
      throw AdbAgentClientException(message: response.error.message);
    }

    assert(
      (response.whichPayload() == .getInfo) && response.hasGetInfo(),
      "Received unexpected response from agent.",
    );

    return response.getInfo;
  }

  Future<CaptureScreenshotResponse> captureScreenshot() async {
    final response = await _sendToSocket(
      AgentRequest(captureScreenshot: CaptureScreenshotRequest()),
    );

    if (response.whichPayload() == .error) {
      assert(response.hasError(), "Received Error object without being set.");
      throw AdbAgentClientException(message: response.error.message);
    }

    assert(
      (response.whichPayload() == .captureScreenshot) &&
          response.hasCaptureScreenshot(),
      "Received unexpected response from agent.",
    );

    return response.captureScreenshot;
  }

  Future<AgentResponse> _sendToSocket(AgentRequest request) async {
    final requestPayload = request.writeToBuffer();
    final header = ByteData(4)..setUint32(0, requestPayload.length, Endian.big);

    // Send request
    socket.add(header.buffer.asUint8List());
    socket.add(requestPayload);

    // Receive response
    final lengthBytes = await bytes.take(4);
    if (lengthBytes.length < 4) {
      throw AdbAgentClientException(
        message: 'Agent connection closed while waiting for a response.',
      );
    }

    final length = ByteData.sublistView(Uint8List.fromList(lengthBytes))
        .getUint32(0, Endian.big);
    final responsePayload = await bytes.take(length);
    if (responsePayload.length < length) {
      throw AdbAgentClientException(
        message: 'Agent connection closed while waiting for a response.',
      );
    }

    return AgentResponse.fromBuffer(responsePayload);
  }
}
