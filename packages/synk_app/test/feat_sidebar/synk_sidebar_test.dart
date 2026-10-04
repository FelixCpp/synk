import 'package:bench_ui/bench_ui.dart';
import 'package:synk/feat_device_agent/application/android_device_agent.dart';
import 'package:synk/feat_device_agent/application/ios_device_agent.dart';
import 'package:synk/feat_device_agent/domain/models/screen_capture_agent.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device_connection.dart';
import 'package:synk/feat_plugged_devices/adb/domain/models/android_device_state.dart';
import 'package:synk/feat_plugged_devices/adb/domain/repositories/plugged_adb_devices_repository.dart';
import 'package:synk/feat_plugged_devices/domain/models/device_id.dart';
import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:synk/feat_plugged_devices/ios/domain/models/ios_device.dart';
import 'package:synk/feat_plugged_devices/ios/domain/repositories/plugged_ios_devices_repository.dart';
import 'package:synk/feat_sidebar/presentation/synk_sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAdbDevicesRepository implements PluggedAdbDevicesRepository {
  FakeAdbDevicesRepository(this.devices);

  final List<AndroidDevice> devices;

  @override
  Stream<List<AndroidDevice>> observeAdbDevices() => Stream.value(devices);
}

class FakeIosDevicesRepository implements PluggedIosDevicesRepository {
  @override
  Stream<List<IosDevice>> observeIosDevices() => Stream.value(const []);
}

class FakeDeviceConnectionsRepository implements DeviceConnectionsRepository {
  @override
  Future<void> toggleConnection(PluggedDevice device) async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<bool> isConnected(DeviceId id) async => false;

  @override
  Stream<List<PluggedDevice>> observeConnectingDevices() => Stream.value(
    const [],
  );

  @override
  Stream<List<DeviceConnection>> observeDeviceConnections() => Stream.value(
    const [],
  );

  @override
  AndroidDeviceAgent? getAndroidDeviceAgent(DeviceId id) => null;

  @override
  IosDeviceAgent? getIosDeviceAgent(DeviceId id) => null;

  @override
  ScreenCaptureAgent? getScreenCaptureAgent(DeviceId id) => null;
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
    BenchTheme(
      data: BenchThemeData.forBrightness(Brightness.dark),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<NotificationService>(
            create: (context) => NotificationService(),
          ),
          RepositoryProvider<PluggedAdbDevicesRepository>(
            create: (context) => FakeAdbDevicesRepository(devices),
          ),
          RepositoryProvider<PluggedIosDevicesRepository>(
            create: (context) => FakeIosDevicesRepository(),
          ),
          RepositoryProvider<DeviceConnectionsRepository>(
            create: (context) => FakeDeviceConnectionsRepository(),
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
      expect(find.byType(BenchTag), findsNothing);
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
        expect(find.text('NICHT AUTORISIERT'), findsNWidgets(2));
        expect(find.byType(BenchTag), findsOneWidget);
        expect(find.byIcon(CupertinoIcons.bolt_fill), findsNothing);
        expect(find.byIcon(CupertinoIcons.bolt_slash_fill), findsNothing);
      },
    );

    testWidgets('separates authorized and unauthorized devices', (
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
      expect(find.text('NICHT AUTORISIERT'), findsNWidgets(2));
      expect(find.byIcon(CupertinoIcons.bolt_fill), findsOneWidget);
    });
  });
}
