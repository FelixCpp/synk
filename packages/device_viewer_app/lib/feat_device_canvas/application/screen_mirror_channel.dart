import 'package:flutter/services.dart';

/// Bridges to the native `ScreenMirrorPlugin` (macOS: VideoToolbox decode +
/// FlutterTexture). Only one mirror session is supported at a time - the
/// native side owns a single texture/decode session, matching the "one
/// active mirror" scoping of [DeviceCanvasBloc].
class ScreenMirrorChannel {
  static const _methodChannel = MethodChannel('dev.deviceviewer/screen_mirror');
  static const _videoChunkChannel = BasicMessageChannel<ByteData?>(
    'dev.deviceviewer/screen_mirror/video_chunk',
    BinaryCodec(),
  );

  Future<int> createTexture() async {
    final id = await _methodChannel.invokeMethod<int>('createTexture');
    return id!;
  }

  Future<void> start() => _methodChannel.invokeMethod('start');

  Future<void> stop() => _methodChannel.invokeMethod('stop');

  void sendChunk(Uint8List chunk) {
    _videoChunkChannel.send(
      chunk.buffer.asByteData(chunk.offsetInBytes, chunk.length),
    );
  }
}
