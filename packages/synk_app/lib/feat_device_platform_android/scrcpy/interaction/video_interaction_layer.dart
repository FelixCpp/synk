import 'dart:io';

class VideoInteractionLayer(final Socket interactionSocket) {
  static const scrcpyResetVideoEventId = 17;

  void resetVideo() {
    interactionSocket.add([scrcpyResetVideoEventId]);
  }
}
