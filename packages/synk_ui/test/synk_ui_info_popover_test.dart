import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Widget child) {
    return WidgetsApp(
      color: const Color(0xFF000000),
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        );
      },
      home: SynkUiTheme(
        data: SynkUiThemeData.dark,
        child: Center(child: child),
      ),
    );
  }

  testWidgets('SynkUiInfoPopover shows title and rows once opened', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        SynkUiInfoPopover(
          title: 'Pixel 6',
          rows: const [
            SynkUiInfoRow(label: 'Modell', value: 'Pixel 6'),
            SynkUiInfoRow(label: 'Seriennummer', value: '18131FDF6002UE'),
          ],
          triggerBuilder: (context, controller) => SynkUiIconButton(
            icon: CupertinoIcons.info_circle,
            onPressed: controller.open,
          ),
        ),
      ),
    );

    expect(find.text('Pixel 6'), findsNothing);
    expect(find.text('Modell'), findsNothing);

    await tester.tap(find.byType(SynkUiIconButton));
    await tester.pumpAndSettle();

    expect(find.text('Pixel 6'), findsWidgets);
    expect(find.text('Modell'), findsOneWidget);
    expect(find.text('Seriennummer'), findsOneWidget);
    expect(find.text('18131FDF6002UE'), findsOneWidget);
  });

  testWidgets('SynkUiInfoPopover closes when tapping outside', (tester) async {
    await tester.pumpWidget(
      buildApp(
        SynkUiInfoPopover(
          title: 'Pixel 6',
          rows: const [SynkUiInfoRow(label: 'Modell', value: 'Pixel 6')],
          triggerBuilder: (context, controller) => SynkUiIconButton(
            icon: CupertinoIcons.info_circle,
            onPressed: controller.open,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(SynkUiIconButton));
    await tester.pumpAndSettle();
    expect(find.text('Modell'), findsOneWidget);

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(find.text('Modell'), findsNothing);
  });
}
