import 'dart:typed_data';

import 'package:synk/feat_clipboard/domain/clipboard_feature.dart';

/// A clipboard that keeps whatever it is handed, and can refuse on demand.
class FakeClipboardFeature implements ClipboardFeature {
  FakeClipboardFeature({this.text});

  String? text;
  final images = <Uint8List>[];
  bool fails = false;

  @override
  Future<String?> readText() async => text;

  @override
  Future<void> writeText(String text) async {
    _guard();
    this.text = text;
  }

  @override
  Future<void> writeImage(Uint8List bytes) async {
    _guard();
    images.add(bytes);
  }

  void _guard() {
    if (fails) {
      throw Exception('no pasteboard here');
    }
  }
}
