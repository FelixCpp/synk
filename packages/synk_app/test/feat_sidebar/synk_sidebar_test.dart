import 'package:synk/feat_tool_validation/domain/models/tool_availability.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_sidebar/presentation/synk_sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeDeviceConnectionsRepository implements DeviceConnectionsRepository {
  FakeDeviceConnectionsRepository(this.devices);

  final List<PluggedDevice> devices;

  @override
  Stream<List<PluggedDevice>> observePluggedDevices() {
    return Stream.value(devices);
  }

  @override
  Future<void> toggleConnection(PluggedDevice device) async {}

  @override
  Future<void> dispose() async {}

  @override
  bool isConnected(DeviceId id) => false;

  @override
  Stream<Map<DeviceId, DeviceConnectionState>> observeConnectionStates() {
    return Stream.value(const {});
  }

  @override
  Stream<List<DeviceConnection>> observeDeviceConnections() => Stream.value(
    const [],
  );
}

AndroidDevice _buildAndroidDevice(
  String serial, {
  required AndroidDeviceState state,
}) {
  return AndroidDevice(
    id: DeviceId(serial),
    modelName: 'Pixel $serial',
    state: state,
    connection: AndroidDeviceConnection.usb,
  );
}

Future<void> _pumpSidebar(
  WidgetTester tester,
  List<AndroidDevice> devices,
) async {
  await tester.pumpWidget(
    SynkUiTheme(
      data: SynkUiThemeData.forBrightness(Brightness.dark),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<NotificationService>(
            create: (context) => NotificationService(),
          ),
          RepositoryProvider.value(
            value: const ToolAvailability(
              isAdbAvailable: true,
              isDevicectlAvailable: true,
            ),
          ),
          RepositoryProvider<DeviceConnectionsRepository>(
            create: (context) => FakeDeviceConnectionsRepository(devices),
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
          home: const SynkSidebar(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('SynkSidebar', () {
    testWidgets('shows a connect button for an authorized device', (
      tester,
    ) async {
      await _pumpSidebar(tester, [
        _buildAndroidDevice('serial-1', state: AndroidDeviceState.device),
      ]);

      expect(find.text('Pixel serial-1'), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.bolt_fill), findsOneWidget);
      expect(find.byType(SynkUiTag), findsNothing);
      expect(find.text('NICHT AUTORISIERT'), findsNothing);
    });

    testWidgets(
      'marks an unauthorized device and hides its connect button',
      (tester) async {
        await _pumpSidebar(tester, [
          _buildAndroidDevice(
            'serial-2',
            state: AndroidDeviceState.unauthorized,
          ),
        ]);

        expect(find.text('Pixel serial-2'), findsOneWidget);
        expect(find.byType(SynkUiTag), findsOneWidget);
        expect(find.text('NICHT AUTORISIERT'), findsOneWidget);
        expect(find.byIcon(CupertinoIcons.bolt_fill), findsNothing);
        expect(find.byIcon(CupertinoIcons.bolt_slash_fill), findsNothing);
      },
    );

    testWidgets('lists authorized and unauthorized devices together', (
      tester,
    ) async {
      await _pumpSidebar(tester, [
        _buildAndroidDevice('serial-3', state: AndroidDeviceState.device),
        _buildAndroidDevice(
          'serial-4',
          state: AndroidDeviceState.unauthorized,
        ),
      ]);

      expect(find.text('Pixel serial-3'), findsOneWidget);
      expect(find.text('Pixel serial-4'), findsOneWidget);
      expect(find.byType(SynkUiTag), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.bolt_fill), findsOneWidget);
    });
  });
}
