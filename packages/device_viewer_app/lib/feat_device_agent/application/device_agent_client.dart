import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';

import 'package:device_viewer/feat_device_agent/generated/device_agent.pb.dart';

class const AdbAgentClientException({required final String message})
    implements Exception {
  @override
  String toString() => 'AdbAgentClientException: $message';
}

class DeviceAgentClient({
  required final Socket socket,
}) {
  final bytes = StreamQueue(socket.expand((chunk) => chunk));

  this {
    // A failed write (e.g. the agent process died or the adb port forward
    // was torn down) completes `socket.done` with an error on a path that
    // isn't awaited anywhere. Left unhandled, that surfaces as an uncaught
    // SocketException outside of `_call`'s try/catch. The actual failure is
    // still reported to callers via the `bytes` stream erroring out.
    unawaited(socket.done.catchError((_) {}));
  }

  Future<GetInfoResponse> fetchInfo() async {
    final response = await _call(AgentRequest(getInfo: GetInfoRequest()));

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
    final response = await _call(
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

  Future<int> startScreenStream() async {
    final response = await _call(
      AgentRequest(startScreenStream: StartScreenStreamRequest()),
    );

    if (response.whichPayload() == .error) {
      assert(response.hasError(), "Received Error object without being set.");
      throw AdbAgentClientException(message: response.error.message);
    }

    assert(
      (response.whichPayload() == .startScreenStream) &&
          response.hasStartScreenStream(),
      "Received unexpected response from agent.",
    );

    return response.startScreenStream.videoPort;
  }

  Future<void> stopScreenStream() async {
    final response = await _call(
      AgentRequest(stopScreenStream: StopScreenStreamRequest()),
    );

    if (response.whichPayload() == .error) {
      assert(response.hasError(), "Received Error object without being set.");
      throw AdbAgentClientException(message: response.error.message);
    }

    assert(
      (response.whichPayload() == .stopScreenStream) &&
          response.hasStopScreenStream(),
      "Received unexpected response from agent.",
    );
  }

  Future<AgentResponse> _call(AgentRequest request) async {
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

  Future<void> dispose() {
    return socket.close();
  }
}
