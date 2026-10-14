import 'package:flutter/services.dart';
import 'package:pasteboard/pasteboard.dart';

abstract interface class HostClipboard {
  Future<String?> readText();
  Future<void> writeText(String text);
  Future<void> writeImage(Uint8List bytes);
}

class const SystemHostClipboard() implements HostClipboard {
  @override
  Future<String?> readText() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }

  @override
  Future<void> writeText(String text) {
    return Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Future<void> writeImage(Uint8List bytes) {
    return Pasteboard.writeImage(bytes);
  }
}
