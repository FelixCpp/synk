import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

/// `DeviceKeyEvent` models a keystroke with Flutter's own `LogicalKeyboardKey`
/// and `PhysicalKeyboardKey`, so anything reading a keystroke reaches for
/// Flutter. Listed rather than waved through: the way out is a key enum of
/// Synk's own, and until there is one this list is the record of what it would
/// cost.
const _domainFilesAllowedToUseFlutter = {
  'feat_device_platform/domain/models/device_input.dart',
  'feat_device_frame/domain/device_clipboard_sync.dart',
};

void main() {
  final sources = _dartSourcesUnder('lib');

  test('finds the sources it is supposed to check', () {
    expect(sources, hasLength(greaterThan(50)));
  });

  group('the domain', () {
    test('does not reach into data', () {
      _expectNoImports(
        sources.where(_isDomain),
        matching: RegExp(r'/data/'),
      );
    });

    test('does not reach into presentation', () {
      _expectNoImports(
        sources.where(_isDomain),
        matching: RegExp(r'/presentation/'),
      );
    });

    test('does not depend on Flutter, bar the listed exception', () {
      _expectNoImports(
        sources.where(_isDomain).where(
          (source) => !_domainFilesAllowedToUseFlutter.contains(
            _featureRelative(source),
          ),
        ),
        matching: RegExp(r'package:(flutter|flutter_bloc)/'),
      );
    });
  });

  group('the presentation', () {
    test('builds nothing from data, only from what domain declares', () {
      _expectNoImports(
        sources.where(_isPresentation),
        matching: RegExp(r'/data/'),
      );
    });
  });

  group('the data layer', () {
    test('does not reach back into presentation', () {
      _expectNoImports(
        sources.where(_isData),
        matching: RegExp(r'/presentation/'),
      );
    });
  });
}

bool _isDomain(File source) => source.path.contains('/domain/');
bool _isData(File source) => source.path.contains('/data/');
bool _isPresentation(File source) => source.path.contains('/presentation/');

void _expectNoImports(Iterable<File> sources, {required RegExp matching}) {
  final offenders = <String>[];

  for (final source in sources) {
    for (final import in _importsOf(source)) {
      if (matching.hasMatch(import)) {
        offenders.add('${_featureRelative(source)} -> $import');
      }
    }
  }

  expect(offenders, isEmpty);
}

Iterable<String> _importsOf(File source) {
  final imports = RegExp(r"""^import\s+['"]([^'"]+)['"]""", multiLine: true);

  return imports
      .allMatches(source.readAsStringSync())
      .map((match) => match.group(1)!);
}

String _featureRelative(File source) {
  return path.relative(source.path, from: 'lib').replaceAll(r'\', '/');
}

List<File> _dartSourcesUnder(String directory) {
  return Directory(directory)
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .where((file) => !file.path.endsWith('.freezed.dart'))
      .where((file) => !file.path.endsWith('.g.dart'))
      .where((file) => !file.path.contains('/generated/'))
      .toList();
}
