import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk_ui/synk_ui.dart';

const _copyIcon = IconData(0xe000);
const _message = 'Die Kopplung ist fehlgeschlagen: wrong code';

void main() {
  Widget buildApp() {
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
        child: const Center(
          child: SynkUiSelectableText(_message, copyIcon: _copyIcon),
        ),
      ),
    );
  }

  testWidgets('copies a selected message from its context menu', (
    tester,
  ) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await tester.pumpWidget(buildApp());

    final text = tester.getRect(find.text(_message));
    final drag = await tester.startGesture(
      text.centerLeft + const Offset(1.0, 0.0),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pump();
    await drag.moveTo(text.centerRight - const Offset(1.0, 0.0));
    await drag.up();
    await tester.pump();

    await tester.tapAt(
      text.center,
      buttons: kSecondaryMouseButton,
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Kopieren'));
    await tester.pumpAndSettle();

    expect(copied, _message);
  }, variant: TargetPlatformVariant.only(TargetPlatform.macOS));
}
