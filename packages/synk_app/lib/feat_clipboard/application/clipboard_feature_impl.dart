import 'package:flutter/services.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:synk/feat_clipboard/domain/clipboard_feature.dart';

class const ClipboardFeatureImpl() implements ClipboardFeature {
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
