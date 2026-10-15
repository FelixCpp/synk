import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_platform_android/bundled_files.dart';

import '../support/fake_asset_bundle.dart';

void main() {
  late FakeAssetBundle bundle;
  late MemoryFileSystem fileSystem;
  late BundledFiles bundledFiles;

  setUp(() {
    bundle = FakeAssetBundle({
      'assets/bundled_files/classes.dex': [1, 2, 3],
    });
    fileSystem = MemoryFileSystem();
    bundledFiles = BundledFiles(
      bundle: bundle,
      fileSystem: fileSystem,
      directory: '/cache',
    );
  });

  test('writes the asset under the name it is asked for', () async {
    final path = await bundledFiles.pathOf(
      'assets/bundled_files/classes.dex',
      filename: 'device_agent.dex',
    );

    expect(path, '/cache/device_agent.dex');
    expect(fileSystem.file(path).readAsBytesSync(), [1, 2, 3]);
  });

  test('writes each asset only once', () async {
    for (var i = 0; i < 3; i++) {
      await bundledFiles.pathOf(
        'assets/bundled_files/classes.dex',
        filename: 'device_agent.dex',
      );
    }

    expect(bundle.loads, hasLength(1));
  });

  test('lets two devices connecting at once share the write', () async {
    final paths = await Future.wait([
      bundledFiles.pathOf(
        'assets/bundled_files/classes.dex',
        filename: 'device_agent.dex',
      ),
      bundledFiles.pathOf(
        'assets/bundled_files/classes.dex',
        filename: 'device_agent.dex',
      ),
    ]);

    expect(paths.toSet(), {'/cache/device_agent.dex'});
    expect(bundle.loads, hasLength(1));
  });
}
