import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_notifications/application/notification_feature_impl.dart';
import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_notifications/domain/notification_feature.dart';
import 'package:synk/feat_notifications/domain/notification_policy.dart';
import 'package:synk/feat_notifications/presentation/app_notification_listener.dart';
import 'package:synk/feat_notifications/presentation/widgets/notification_stack_view.dart';
import 'package:synk_ui/synk_ui.dart';

void main() {
  late NotificationFeature notifications;

  setUp(() => notifications = NotificationFeatureImpl());
  tearDown(() => notifications.dispose());

  Future<void> pumpListener(WidgetTester tester) async {
    await tester.pumpWidget(
      SynkUiTheme(
        data: SynkUiThemeData.forBrightness(Brightness.dark),
        child: WidgetsApp(
          color: CupertinoColors.activeBlue,
          pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
            return PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (context, _, _) => builder(context),
            );
          },
          home: AppNotificationListener(
            notifications: notifications,
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
  }

  Future<void> notify(
    WidgetTester tester,
    String message, {
    NotificationSeverity severity = NotificationSeverity.error,
  }) async {
    notifications.notify(
      AppNotification(message: message, severity: severity),
    );
    await tester.pump();
    await settle(tester);
  }

  double? progressOf(WidgetTester tester, String message) {
    final toast = tester.widget<SynkUiToast>(
      find.ancestor(
        of: find.text(message),
        matching: find.byType(SynkUiToast),
      ),
    );

    return toast.progress;
  }

  double topOf(WidgetTester tester, String message) {
    return tester.getTopLeft(find.text(message)).dy;
  }

  testWidgets('keeps an error until it is dismissed', (tester) async {
    await pumpListener(tester);
    await notify(tester, 'Entwicklermodus aus');

    await tester.pump(const Duration(minutes: 1));
    expect(find.text('Entwicklermodus aus'), findsOneWidget);

    await tester.tap(find.byIcon(CupertinoIcons.clear));
    await settle(tester);
    expect(find.text('Entwicklermodus aus'), findsNothing);
  });

  testWidgets('hangs the stack in the top right, clear of the title strip', (
    tester,
  ) async {
    await pumpListener(tester);
    await notify(tester, 'Erster Fehler');

    final window = tester.getRect(find.byType(AppNotificationListener));
    final stack = tester.getRect(find.byType(NotificationStackView));

    expect(stack.top, SynkUiSize.titleStrip + SynkUiSpace.s16);
    expect(stack.right, window.right - SynkUiSpace.s16);
  });

  testWidgets('keeps a warning until it is dismissed', (tester) async {
    await pumpListener(tester);
    await notify(
      tester,
      'Xcode ist nicht installiert',
      severity: NotificationSeverity.warning,
    );

    await tester.pump(const Duration(minutes: 1));
    await settle(tester);
    expect(find.text('Xcode ist nicht installiert'), findsOneWidget);
  });

  testWidgets('lets a success fade on its own', (tester) async {
    await pumpListener(tester);
    await notify(
      tester,
      'Screenshot gespeichert',
      severity: NotificationSeverity.success,
    );

    expect(find.text('Screenshot gespeichert'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await settle(tester);
    expect(find.text('Screenshot gespeichert'), findsNothing);
  });

  testWidgets('drains the time bar and goes when it is empty', (
    tester,
  ) async {
    await pumpListener(tester);
    await notify(
      tester,
      'Screenshot gespeichert',
      severity: NotificationSeverity.success,
    );

    final atStart = progressOf(tester, 'Screenshot gespeichert');
    expect(atStart, isNotNull);

    await tester.pump(const Duration(seconds: 2));

    expect(
      progressOf(tester, 'Screenshot gespeichert'),
      lessThan(atStart!),
    );

    await tester.pump(const Duration(seconds: 3));
    await settle(tester);
    expect(find.text('Screenshot gespeichert'), findsNothing);
  });

  testWidgets('gives a message that never expires no time bar', (
    tester,
  ) async {
    await pumpListener(tester);
    await notify(tester, 'Entwicklermodus aus');

    expect(progressOf(tester, 'Entwicklermodus aus'), isNull);
  });

  testWidgets('holds the countdown while the pointer rests on the stack', (
    tester,
  ) async {
    await pumpListener(tester);
    await notify(
      tester,
      'Screenshot gespeichert',
      severity: NotificationSeverity.success,
    );

    final pointer = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await pointer.addPointer(location: Offset.zero);
    addTearDown(pointer.removePointer);
    await tester.pump();

    await pointer.moveTo(tester.getCenter(find.text('Screenshot gespeichert')));
    await tester.pump(const Duration(milliseconds: 200));

    final whenHovered = progressOf(tester, 'Screenshot gespeichert');

    await tester.pump(const Duration(seconds: 30));
    await tester.pump();

    expect(find.text('Screenshot gespeichert'), findsOneWidget);
    expect(progressOf(tester, 'Screenshot gespeichert'), whenHovered);

    await pointer.moveTo(Offset.zero);
    await tester.pump();

    await tester.pump(const Duration(seconds: 5));
    await settle(tester);
    expect(find.text('Screenshot gespeichert'), findsNothing);
  });

  testWidgets('keeps counting when the stack grows under a resting pointer', (
    tester,
  ) async {
    await pumpListener(tester);
    await notify(
      tester,
      'Screenshot gespeichert',
      severity: NotificationSeverity.success,
    );

    final card = tester.getRect(find.byType(SynkUiToast));
    final pointer = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await pointer.addPointer(
      location: Offset(card.center.dx, card.bottom + 30.0),
    );
    addTearDown(pointer.removePointer);
    await tester.pump();
    await tester.pump();

    await notify(tester, 'Erster Fehler');

    await tester.pump(const Duration(seconds: 5));
    await settle(tester);
    expect(find.text('Screenshot gespeichert'), findsNothing);
  });

  testWidgets('counts down again once the pointer leaves an emptied stack', (
    tester,
  ) async {
    await pumpListener(tester);
    await notify(tester, 'Erster Fehler');

    final pointer = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await pointer.addPointer(location: Offset.zero);
    addTearDown(pointer.removePointer);
    await tester.pump();

    await pointer.moveTo(tester.getCenter(find.text('Erster Fehler')));
    await tester.pump();

    await tester.tap(find.byIcon(CupertinoIcons.clear));
    await settle(tester);
    expect(find.text('Erster Fehler'), findsNothing);

    await notify(
      tester,
      'Screenshot gespeichert',
      severity: NotificationSeverity.success,
    );

    await pointer.moveTo(Offset.zero);
    await tester.pump();

    await tester.pump(const Duration(seconds: 5));
    await settle(tester);
    expect(find.text('Screenshot gespeichert'), findsNothing);
  });

  testWidgets('puts the newest message on top', (tester) async {
    await pumpListener(tester);
    await notify(tester, 'Erster Fehler');
    await notify(tester, 'Zweiter Fehler');

    expect(
      topOf(tester, 'Zweiter Fehler'),
      lessThan(topOf(tester, 'Erster Fehler')),
    );
  });

  testWidgets('dismisses the messages one by one', (tester) async {
    await pumpListener(tester);
    await notify(tester, 'Erster Fehler');
    await notify(tester, 'Zweiter Fehler');

    await tester.tap(find.byIcon(CupertinoIcons.clear).first);
    await settle(tester);

    expect(find.text('Zweiter Fehler'), findsNothing);
    expect(find.text('Erster Fehler'), findsOneWidget);
  });

  testWidgets('never lets two messages sit on top of each other', (
    tester,
  ) async {
    await pumpListener(tester);
    await notify(tester, 'Erster Fehler');
    await notify(tester, 'Zweiter Fehler');
    await notify(tester, 'Dritter Fehler');

    final cards = [
      for (final message in ['Erster Fehler', 'Zweiter Fehler', 'Dritter Fehler'])
        tester.getRect(
          find.ancestor(
            of: find.text(message),
            matching: find.byType(SynkUiToast),
          ),
        ),
    ];

    for (var i = 0; i < cards.length; i++) {
      for (var j = i + 1; j < cards.length; j++) {
        expect(
          cards[i].overlaps(cards[j]),
          isFalse,
          reason: 'card $i overlaps card $j',
        );
      }
    }
  });

  testWidgets('counts a repeated failure instead of stacking it again', (
    tester,
  ) async {
    await pumpListener(tester);
    await notify(tester, 'Der Tap kam nicht an.');
    await notify(tester, 'Der Tap kam nicht an.');
    await notify(tester, 'Der Tap kam nicht an.');

    expect(find.text('Der Tap kam nicht an.'), findsOneWidget);
    expect(find.text('×3'), findsOneWidget);
  });

  testWidgets('brings a folded-away message back below the newer ones', (
    tester,
  ) async {
    await pumpListener(tester);
    for (var index = 1; index <= NotificationPolicy.maxVisible + 1; index++) {
      await notify(tester, 'Fehler $index');
    }

    expect(find.text('Fehler 1'), findsNothing);
    expect(find.text('+1 weitere'), findsOneWidget);

    await tester.tap(find.byIcon(CupertinoIcons.clear).first);
    await settle(tester);

    expect(find.text('Fehler 5'), findsNothing);
    expect(find.text('+1 weitere'), findsNothing);
    expect(
      topOf(tester, 'Fehler 1'),
      greaterThan(topOf(tester, 'Fehler 2')),
    );
  });

  testWidgets('folds everything past the fourth message into one row', (
    tester,
  ) async {
    await pumpListener(tester);
    for (var index = 1; index <= NotificationPolicy.maxVisible + 2; index++) {
      await notify(tester, 'Fehler $index');
    }

    expect(find.byType(SynkUiToast), findsNWidgets(4));
    expect(find.text('Fehler 1'), findsNothing);
    expect(find.text('Fehler 2'), findsNothing);
    expect(find.text('Fehler 6'), findsOneWidget);
    expect(find.text('+2 weitere'), findsOneWidget);

    await tester.tap(find.byIcon(CupertinoIcons.clear).last);
    await settle(tester);

    expect(find.byType(SynkUiToast), findsNothing);
    expect(find.text('+2 weitere'), findsNothing);
  });
}
