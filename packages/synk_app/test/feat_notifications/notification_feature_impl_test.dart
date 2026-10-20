import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_notifications/application/notification_feature_impl.dart';
import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_notifications/domain/models/notification_entry.dart';
import 'package:synk/feat_notifications/domain/models/notification_stack.dart';
import 'package:synk/feat_notifications/domain/notification_policy.dart';

void main() {
  late NotificationFeatureImpl notifications;

  setUp(() => notifications = NotificationFeatureImpl());
  tearDown(() => notifications.dispose());

  Future<NotificationStack> stackNow() => notifications.observeStack().first;

  Future<List<String>> messagesOnStack() async {
    final stack = await stackNow();

    return stack.entries
        .map((entry) => entry.notification.message)
        .toList();
  }

  void notify(String message, {NotificationSeverity severity = .error}) {
    notifications.notify(
      AppNotification(message: message, severity: severity),
    );
  }

  test('reports the share of standing time an entry has left', () {
    const entry = NotificationEntry(
      id: 1,
      notification: AppNotification(message: 'Gespeichert', severity: .success),
      lifetime: Duration(seconds: 4),
      remaining: Duration(seconds: 1),
    );

    expect(entry.timeLeft, 0.25);
  });

  test('reports no standing time for an entry that waits to be dismissed', () {
    const entry = NotificationEntry(
      id: 1,
      notification: AppNotification(message: 'Fehlgeschlagen'),
    );

    expect(entry.timeLeft, isNull);
  });

  test('hands out the standing time the policy gives a success', () async {
    notify('Gespeichert', severity: .success);

    final entry = (await stackNow()).entries.single;

    expect(entry.lifetime, NotificationPolicy.lifetimeOf(.success));
    expect(entry.remaining, entry.lifetime);
  });

  test('puts the newest message last', () async {
    notify('Erster');
    notify('Zweiter');

    expect(await messagesOnStack(), ['Erster', 'Zweiter']);
  });

  test('counts a repeated message instead of adding a second entry', () async {
    notify('Der Tap kam nicht an.');
    notify('Der Tap kam nicht an.');
    notify('Der Tap kam nicht an.');

    final entries = (await stackNow()).entries;

    expect(entries, hasLength(1));
    expect(entries.single.count, 3);
  });

  test('leaves a repeated message where it already was', () async {
    notify('Erster');
    notify('Zweiter');
    notify('Erster');

    expect(await messagesOnStack(), ['Erster', 'Zweiter']);
  });

  test('tells the same text apart by severity', () async {
    notify('Gleicher Text', severity: .error);
    notify('Gleicher Text', severity: .success);

    expect((await stackNow()).entries, hasLength(2));
  });

  test('reports every message, repeats included', () async {
    final reported = <String>[];
    final subscription = notifications.observeNotifications().listen(
      (notification) => reported.add(notification.message),
    );
    addTearDown(subscription.cancel);

    notify('Der Tap kam nicht an.');
    notify('Der Tap kam nicht an.');
    await pumpEventQueue();

    expect(reported, hasLength(2));
  });

  test('shows the newest four and folds the rest away', () async {
    for (var index = 1; index <= NotificationPolicy.maxVisible + 2; index++) {
      notify('Fehler $index');
    }

    final stack = await stackNow();

    expect(stack.entries, hasLength(6));
    expect(stack.hiddenCount, 2);
    expect(
      stack.visible.map((entry) => entry.notification.message),
      ['Fehler 3', 'Fehler 4', 'Fehler 5', 'Fehler 6'],
    );
  });

  test('folds nothing away while there is room', () async {
    notify('Erster');
    notify('Zweiter');

    final stack = await stackNow();

    expect(stack.hiddenCount, 0);
    expect(stack.visible, stack.entries);
  });

  test('dismisses one message by id and leaves the others', () async {
    notify('Erster');
    notify('Zweiter');

    final first = (await stackNow()).entries.first;
    notifications.dismiss(first.id);

    expect(await messagesOnStack(), ['Zweiter']);
  });

  test('clears the whole stack at once', () async {
    notify('Erster');
    notify('Zweiter');
    notifications.dismissAll();

    expect(await messagesOnStack(), isEmpty);
  });

  test('takes a dismissed message back as a new entry', () async {
    notify('Erster');
    final first = (await stackNow()).entries.single;
    notifications.dismiss(first.id);

    notify('Erster');
    final again = (await stackNow()).entries.single;

    expect(again.count, 1);
    expect(again.id, isNot(first.id));
  });
}
