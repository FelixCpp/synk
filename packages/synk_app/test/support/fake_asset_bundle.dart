import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// A bundle holding exactly the [assets] it is handed, that counts how often
/// each one is loaded.
class FakeAssetBundle extends AssetBundle {
  FakeAssetBundle(this.assets);

  final Map<String, List<int>> assets;
  final loads = <String>[];

  @override
  Future<ByteData> load(String key) async {
    loads.add(key);

    final bytes = assets[key];
    if (bytes == null) {
      throw FlutterError('No asset $key in this bundle');
    }

    return ByteData.sublistView(Uint8List.fromList(bytes));
  }

  @override
  Future<T> loadStructuredData<T>(
    String key,
    Future<T> Function(String value) parser,
  ) async {
    return parser(await loadString(key));
  }
}
