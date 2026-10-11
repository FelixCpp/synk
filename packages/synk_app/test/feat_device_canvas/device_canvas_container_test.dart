import 'package:synk/feat_device_agent/application/android_device_agent.dart';
import 'package:synk/feat_device_agent/domain/models/audio_agent.dart';
import 'package:synk/feat_device_agent/domain/models/clipboard_agent.dart';
import 'package:synk/feat_device_agent/domain/models/interaction_agent.dart';
import 'package:synk/feat_device_agent/domain/models/screen_capture_agent.dart';
import 'package:synk/feat_device_canvas/presentation/device_canvas_container.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';
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

  @override
  AndroidDeviceAgent? getAndroidDeviceAgent(DeviceId id) => null;

  @override
  ScreenCaptureAgent? getScreenCaptureAgent(DeviceId id) => null;

  @override
  ClipboardAgent? getClipboardAgent(DeviceId id) => null;

  @override
  AudioAgent? getAudioAgent(DeviceId id) => null;

  @override
  InteractionAgent? getInteractionAgent(DeviceId id) => null;
}
