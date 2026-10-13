import 'package:synk/feat_device_canvas/presentation/device_canvas_container.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  group('DeviceCanvasContainer', () {
    testWidgets('asks for a device while nothing is mirrored or connecting', (
      tester,
    ) async {
      final connections = _FakeConnections();
      await _pumpCanvas(tester, connections);
      await tester.pumpAndSettle();

      expect(find.text('Keine Geräte aktiv'), findsOneWidget);
      expect(find.byType(SynkUiSpinner), findsNothing);

      await connections.dispose();
    });
  });
}

Future<void> _pumpCanvas(
  WidgetTester tester,
  _FakeConnections connections,
) async {
  await tester.pumpWidget(
    SynkUiTheme(
      data: SynkUiThemeData.forBrightness(Brightness.dark),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<NotificationService>(
            create: (context) => NotificationService(),
          ),
          RepositoryProvider<DeviceConnectionsRepository>.value(
            value: connections,
          ),
        ],
        child: WidgetsApp(
          color: CupertinoColors.activeBlue,
          pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
            return PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (context, _, _) => builder(context),
            );
          },
          home: const DeviceCanvasContainer(),
        ),
      ),
    ),
  );
}

class _FakeConnections implements DeviceConnectionsRepository {
  @override
  Stream<List<PluggedDevice>> observePluggedDevices() {
    return Stream.value(const []);
  }

  final _connections = BehaviorSubject.seeded(<DeviceConnection>[]);

  @override
  Future<void> dispose() => _connections.close();

  @override
  Stream<List<DeviceConnection>> observeDeviceConnections() => _connections;

  @override
  Stream<Map<DeviceId, DeviceConnectionState>> observeConnectionStates() {
    return Stream.value(const {});
  }

  @override
  Future<void> toggleConnection(PluggedDevice device) async {}

  @override
  bool isConnected(DeviceId id) => false;
}
