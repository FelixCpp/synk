import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_settings/presentation/settings_shortcut.dart';

Future<void> _pressCommandComma(WidgetTester tester) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
  await tester.sendKeyEvent(LogicalKeyboardKey.comma);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
}

Future<void> _pump(
  WidgetTester tester, {
  required VoidCallback onInvoke,
  Widget child = const SizedBox.expand(),
}) {
  return tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: SettingsShortcut(onInvoke: onInvoke, child: child),
    ),
  );
}

void main() {
  group('SettingsShortcut', () {
    testWidgets('fires with nothing in the subtree focused', (tester) async {
      var invocations = 0;

      await _pump(tester, onInvoke: () => invocations++);
      await tester.pumpAndSettle();

      await _pressCommandComma(tester);

      expect(invocations, 1, reason: 'an idle window still has to answer ⌘,');
    });

    testWidgets('fires while a child holds the focus', (tester) async {
      var invocations = 0;
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await _pump(
        tester,
        onInvoke: () => invocations++,
        child: Focus(focusNode: focusNode, child: const SizedBox.expand()),
      );
      focusNode.requestFocus();
      await tester.pumpAndSettle();

      await _pressCommandComma(tester);

      expect(invocations, 1);
    });

    testWidgets('leaves an unrelated key alone', (tester) async {
      var invocations = 0;

      await _pump(tester, onInvoke: () => invocations++);
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.comma);

      expect(invocations, 0);
    });
  });
}
