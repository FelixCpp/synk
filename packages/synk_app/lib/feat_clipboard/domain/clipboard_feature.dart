import 'dart:typed_data';

/// What Synk can do with the clipboard of the Mac it runs on.
abstract interface class ClipboardFeature {
  Future<String?> readText();
  Future<void> writeText(String text);
  Future<void> writeImage(Uint8List bytes);
}
