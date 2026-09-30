import 'dart:math' as math;

import 'package:device_viewer/design/build_context.dart';
import 'package:device_viewer/design/theme/device_viewer_colors.dart';
import 'package:bench_ui/bench_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeviceViewerColors', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      group('in ${brightness.name} appearance', () {
        testWidgets('paints text readably on every app surface', (
          tester,
        ) async {
          final colors = await _resolve(tester, brightness);

          for (final surface in [colors.canvas, colors.card, colors.cardHover]) {
            expect(
              _contrastOn(colors.label, surface, colors.canvas),
              greaterThanOrEqualTo(4.5),
              reason: 'primary text on ${_hex(surface)}',
            );
            expect(
              _contrastOn(colors.secondaryLabel, surface, colors.canvas),
              greaterThanOrEqualTo(3.0),
              reason: 'secondary text on ${_hex(surface)}',
            );
            expect(
              _contrastOn(colors.error, surface, colors.canvas),
              greaterThanOrEqualTo(3.0),
              reason: 'error tint on ${_hex(surface)}',
            );
          }
        });

        testWidgets('tells a card apart from the canvas behind it', (
          tester,
        ) async {
          final colors = await _resolve(tester, brightness);

          expect(
            (_asPainted(colors.card).computeLuminance() -
                    _asPainted(colors.canvas).computeLuminance())
                .abs(),
            greaterThan(0.005),
            reason: 'card ${_hex(colors.card)} vs canvas '
                '${_hex(colors.canvas)}',
          );
        });
      });
    }

    test('keeps the connecting overlay readable on its own backdrop', () {
      for (final backdrop in DeviceViewerColors.mirrorBackdrop) {
        expect(
          _contrast(DeviceViewerColors.mirrorLabel, backdrop),
          greaterThanOrEqualTo(4.5),
          reason: 'connecting caption on ${_hex(backdrop)}',
        );
      }
    });
  });
}

Future<DeviceViewerColors> _resolve(
  WidgetTester tester,
  Brightness brightness,
) async {
  late DeviceViewerColors resolved;

  await tester.pumpWidget(
    BenchTheme(
      data: BenchThemeData.forBrightness(brightness),
      child: Builder(
        builder: (context) {
          resolved = context.colors;
          return const SizedBox();
        },
      ),
    ),
  );

  return resolved;
}

Color _asPainted(Color color) => Color(color.toARGB32());

double _contrastOn(Color color, Color surface, Color beneath) {
  return _contrast(
    color,
    Color.alphaBlend(_asPainted(surface), _asPainted(beneath)),
  );
}

double _contrast(Color color, Color opaqueBackground) {
  final background = _asPainted(opaqueBackground);
  final a = Color.alphaBlend(
    _asPainted(color),
    background,
  ).computeLuminance();
  final b = background.computeLuminance();
  return (math.max(a, b) + 0.05) / (math.min(a, b) + 0.05);
}

String _hex(Color color) =>
    '#${color.toARGB32().toRadixString(16).padLeft(8, '0')}';
