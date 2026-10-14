import 'dart:io';
import 'dart:typed_data';

/// Turns the physical display of the mirrored device on or off.
///
/// The message id and payload were read off the bundled scrcpy server:
/// `ControlMessageReader.read` dispatches id 10 to `parseSetDisplayPower`,
/// which reads a single boolean.
class DisplayPowerInteractionLayer(final Socket interactionSocket) {
  static const scrcpySetDisplayPowerEventId = 10;

  void setDisplayPower({required bool on}) {
    final message = ByteData(2)
      ..setUint8(0, scrcpySetDisplayPowerEventId)
      ..setUint8(1, on ? 1 : 0);

    interactionSocket.add(message.buffer.asUint8List());
  }
}
