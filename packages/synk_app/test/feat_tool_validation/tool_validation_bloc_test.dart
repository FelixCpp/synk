import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';
import 'package:synk/feat_tool_validation/domain/repositories/tool_validation_repository.dart';
import 'package:synk/feat_tool_validation/presentation/bloc/tool_validation_bloc.dart';

const _adbIssue = ToolIssue(tool: .adb, problem: .notFound);
const _devicectlIssue = ToolIssue(tool: .devicectl, problem: .notRunnable);

class _Repository(final List<ToolIssue> Function() issues)
    implements ToolValidationRepository {
  @override
  Future<List<ToolIssue>> validateTools() async => issues();
}

extension on ToolValidationState {
  List<ToolIssue>? get warnings => mapOrNull(toolsAvailable: (s) => s.warnings);
  List<ToolIssue>? get issues => mapOrNull(toolsUnavailable: (s) => s.issues);
  bool get isLoading => mapOrNull(loading: (_) => true) ?? false;
}

ToolValidationBloc _bloc(
  List<ToolIssue> Function() issues, [
  NotificationService? notifications,
]) {
  return ToolValidationBloc(
    _Repository(issues),
    notifications ?? NotificationService(),
  );
}

void main() {
  test('starts loading, then makes the tools available', () async {
    final bloc = _bloc(() => const []);
    addTearDown(bloc.close);

    expect(bloc.state.isLoading, isTrue);
    expect((await bloc.stream.first).warnings, isEmpty);
  });

  test('keeps optional tool problems as warnings', () async {
    final bloc = _bloc(() => const [_devicectlIssue]);
    addTearDown(bloc.close);

    expect((await bloc.stream.first).warnings, const [_devicectlIssue]);
  });

  test('keeps the app usable when only adb is broken', () async {
    final bloc = _bloc(() => const [_adbIssue]);
    addTearDown(bloc.close);

    expect((await bloc.stream.first).warnings, const [_adbIssue]);
  });

  test('reports unavailable tools and recovers on retry', () async {
    var broken = true;
    final bloc = _bloc(
      () => broken ? const [_adbIssue, _devicectlIssue] : const [],
    );
    addTearDown(bloc.close);

    expect(
      (await bloc.stream.first).issues,
      const [_adbIssue, _devicectlIssue],
    );

    broken = false;
    final next = bloc.stream.firstWhere((s) => s.warnings != null);
    bloc.add(const .onValidate());

    expect((await next).warnings, isEmpty);
  });

  test('surfaces a throwing validation as a message of its own, not as the '
      'exception text', () async {
    final notifications = NotificationService();
    final shown = <AppNotification>[];
    final subscription = notifications.observeNotifications().listen(shown.add);
    addTearDown(subscription.cancel);

    final bloc = _bloc(
      () => throw const FileSystemException('boom'),
      notifications,
    );
    addTearDown(bloc.close);

    await pumpEventQueue();

    expect(bloc.state.issues, isEmpty);
    expect(
      shown.single.message,
      'Die benötigten Werkzeuge ließen sich nicht prüfen.',
    );
  });
}
