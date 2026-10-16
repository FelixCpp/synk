import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_notifications/presentation/app_notification_listener.dart';
import 'package:synk_ui/synk_ui.dart';

void main() {
  late NotificationService notifications;

  setUp(() => notifications = NotificationService());
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

  Future<void> notify(
    WidgetTester tester,
    String message, {
    NotificationSeverity severity = NotificationSeverity.error,
  }) async {
    notifications.notify(
      AppNotification(message: message, severity: severity),
    );
    await tester.pump();
    await tester.pump();
  }

  testWidgets('keeps an error until it is dismissed', (tester) async {
    await pumpListener(tester);
    await notify(tester, 'Entwicklermodus aus');

    await tester.pump(const Duration(minutes: 1));
    expect(find.text('Entwicklermodus aus'), findsOneWidget);

    await tester.tap(find.byIcon(CupertinoIcons.clear));
    await tester.pump();
    expect(find.text('Entwicklermodus aus'), findsNothing);
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
    expect(find.text('Screenshot gespeichert'), findsNothing);
  });

  testWidgets('stacks errors and dismisses them one by one', (tester) async {
    await pumpListener(tester);
    await notify(tester, 'Erster Fehler');
    await notify(tester, 'Zweiter Fehler');

    expect(find.text('Erster Fehler'), findsOneWidget);
    expect(find.text('Zweiter Fehler'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Erster Fehler')).dy,
      lessThan(tester.getTopLeft(find.text('Zweiter Fehler')).dy),
    );

    await tester.tap(find.byIcon(CupertinoIcons.clear).first);
    await tester.pump();

    expect(find.text('Erster Fehler'), findsNothing);
    expect(find.text('Zweiter Fehler'), findsOneWidget);
  });
}
