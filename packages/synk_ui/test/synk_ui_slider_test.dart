import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk_ui/synk_ui.dart';

void main() {
  Future<List<double>> pumpSlider(
    WidgetTester tester, {
    double value = 0.5,
  }) async {
    final changes = <double>[];

    await tester.pumpWidget(
      SynkUiTheme(
        data: SynkUiThemeData.dark,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: 214.0,
              child: SynkUiSlider(value: value, onChanged: changes.add),
            ),
          ),
        ),
      ),
    );

    return changes;
  }

  testWidgets('a tap jumps to where it lands', (tester) async {
    final changes = await pumpSlider(tester);
    final slider = tester.getRect(find.byType(SynkUiSlider));

    await tester.tapAt(Offset(slider.left + 7.0 + 50.0, slider.center.dy));

    expect(changes.single, closeTo(0.25, 0.001));
  });

  testWidgets('dragging past the end stays within 0 and 1', (tester) async {
    final changes = await pumpSlider(tester);

    await tester.drag(find.byType(SynkUiSlider), const Offset(500.0, 0.0));

    expect(changes, isNotEmpty);
    expect(changes.last, 1.0);
  });
}
