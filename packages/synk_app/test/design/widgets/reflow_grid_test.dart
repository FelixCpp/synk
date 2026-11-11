import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk/design/widgets/reflow_grid.dart';

const _baseCell = Size(100, 200);

Future<void> _pumpGrid(
  WidgetTester tester, {
  required Size viewport,
  required List<int> items,
  double minScale = 0.5,
  double maxScale = 2.0,
}) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: SizedBox.fromSize(
          size: viewport,
          child: ReflowGrid<int>(
            items: items,
            keyOf: (item) => item,
            cellSizeOf: (item, scale) => _baseCell * scale,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            minScale: minScale,
            maxScale: maxScale,
            itemBuilder: (context, item) =>
                SizedBox(key: ValueKey('cell $item')),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Size _cellSize(WidgetTester tester, int item) =>
    tester.getSize(find.byKey(ValueKey('cell $item')));

void main() {
  group('ReflowGrid', () {
    testWidgets('grows a single cell until it fills the viewport height', (
      tester,
    ) async {
      await _pumpGrid(tester, viewport: const Size(600, 300), items: [1]);

      expect(_cellSize(tester, 1).height, closeTo(300, 1));
    });

    testWidgets('never grows a cell past the maximum scale', (tester) async {
      await _pumpGrid(tester, viewport: const Size(800, 800), items: [1]);

      expect(_cellSize(tester, 1), _baseCell * 2.0);
    });

    testWidgets('shrinks the cells so every item stays in view', (
      tester,
    ) async {
      await _pumpGrid(tester, viewport: const Size(300, 150), items: [1, 2]);

      final viewport = tester.getRect(find.byType(ReflowGrid<int>));

      for (final item in [1, 2]) {
        final cell = tester.getRect(find.byKey(ValueKey('cell $item')));

        expect(cell.width, closeTo(75, 0.5));
        expect(cell.height, closeTo(150, 0.5));
        expect(viewport.expandToInclude(cell), viewport);
      }
    });

    testWidgets('scrolls instead of shrinking below the minimum scale', (
      tester,
    ) async {
      await _pumpGrid(
        tester,
        viewport: const Size(120, 100),
        items: [1, 2, 3],
      );

      expect(_cellSize(tester, 1), _baseCell * 0.5);
      expect(find.byType(Scrollable), findsOneWidget);
    });

    testWidgets('centers the rows within the viewport', (tester) async {
      await _pumpGrid(tester, viewport: const Size(600, 300), items: [1]);

      final viewport = tester.getRect(find.byType(ReflowGrid<int>));
      final cell = tester.getRect(find.byKey(const ValueKey('cell 1')));

      expect(cell.center.dx, closeTo(viewport.center.dx, 1));
      expect(cell.center.dy, closeTo(viewport.center.dy, 1));
    });
  });
}
