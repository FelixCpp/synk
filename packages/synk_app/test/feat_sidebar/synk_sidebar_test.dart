import 'package:platform/testing.dart';
import 'package:synk/feat_screen_capture_preview/application/system_file_opener.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_availability.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection_state.dart';
import 'package:synk/feat_device_connections/domain/device_connections_feature.dart';
import 'package:synk/feat_notifications/application/notification_feature_impl.dart';
import 'package:synk/feat_notifications/domain/notification_feature.dart';
import 'package:synk/feat_device_platform_android/discovery/android_device.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_sidebar/application/sidebar_feature_impl.dart';
import 'package:synk/feat_sidebar/domain/sidebar_feature.dart';
import 'package:synk/feat_sidebar/presentation/synk_sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_process_manager.dart';

class FakeDeviceConnectionsFeature implements DeviceConnectionsFeature {
  FakeDeviceConnectionsFeature(this.devices, {this.states = const {}});

  final List<PluggedDevice> devices;
  final Map<DeviceId, DeviceConnectionState> states;

  @override
  Stream<List<PluggedDevice>> observePluggedDevices() {
    return Stream.value(devices);
  }

  @override
  Future<void> connect(PluggedDevice device) async {}

  @override
  Future<void> disconnect(PluggedDevice device) async {}

  @override
  Future<void> disconnectWirelessly(PluggedDevice device) async {}

  @override
  Future<void> dispose() async {}

  @override
  bool isConnected(DeviceId id) => false;

  @override
  Stream<Map<DeviceId, DeviceConnectionState>> observeConnectionStates() {
    return Stream.value(states);
  }

  @override
  Stream<List<DeviceConnection>> observeDeviceConnections() => Stream.value(
    const [],
  );
}

AndroidDevice _buildAndroidDevice(
  String serial, {
  required AndroidDeviceState state,
  AndroidDeviceConnection connection = AndroidDeviceConnection.usb,
}) {
  return AndroidDevice(
    id: DeviceId(serial),
    modelName: 'Pixel $serial',
    state: state,
    connection: connection,
  );
}

Future<void> _pumpSidebar(
  WidgetTester tester,
  List<AndroidDevice> devices, {
  Map<DeviceId, DeviceConnectionState> states = const {},
}) async {
  await tester.pumpWidget(
    SynkUiTheme(
      data: SynkUiThemeData.forBrightness(Brightness.dark),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<NotificationFeature>(
            create: (context) => NotificationFeatureImpl(),
          ),
          RepositoryProvider.value(
            value: const ToolAvailability(
              isAdbAvailable: true,
              isDevicectlAvailable: true,
              isCoreDeviceAvailable: true,
            ),
          ),
          RepositoryProvider.value(
            value: SystemFileOpener(
              processManager: FakeProcessManager(),
              platform: TestNativePlatform(
                operatingSystem: NativePlatform.macOS,
              ),
            ),
          ),
          RepositoryProvider<DeviceConnectionsFeature>(
            create: (context) =>
                FakeDeviceConnectionsFeature(devices, states: states),
          ),
          RepositoryProvider<SidebarFeature>(
            create: (context) => SidebarFeatureImpl(
              connections: RepositoryProvider.of<DeviceConnectionsFeature>(
                context,
              ),
              fileOpener: RepositoryProvider.of<SystemFileOpener>(context),
            ),
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

    testWidgets('marks a wireless device and offers to drop its link', (
      tester,
    ) async {
      await _pumpSidebar(tester, [
        _buildAndroidDevice(
          '192.168.0.79:33651',
          state: AndroidDeviceState.device,
          connection: AndroidDeviceConnection.tcp,
        ),
      ]);

      expect(find.byIcon(CupertinoIcons.wifi), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.bolt_fill), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.wifi_slash), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.link), findsNothing);
    });

    testWidgets('keeps dropping the link apart from ending a mirror', (
      tester,
    ) async {
      await _pumpSidebar(
        tester,
        [
          _buildAndroidDevice(
            '192.168.0.79:33651',
            state: AndroidDeviceState.device,
            connection: AndroidDeviceConnection.tcp,
          ),
        ],
        states: {
          DeviceId('192.168.0.79:33651'):
              const DeviceConnectionState.connected(),
        },
      );

      expect(find.byIcon(CupertinoIcons.wifi), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.bolt_slash_fill), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.wifi_slash), findsNothing);
    });

    testWidgets('offers to pair a rejected wireless device again', (
      tester,
    ) async {
      await _pumpSidebar(tester, [
        _buildAndroidDevice(
          '192.168.0.79:33651',
          state: AndroidDeviceState.unauthorized,
          connection: AndroidDeviceConnection.tcp,
        ),
      ]);

      expect(find.text('NICHT AUTORISIERT'), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.link), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.wifi_slash), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.bolt_fill), findsNothing);
    });

    testWidgets('marks no cable-connected device as wireless', (tester) async {
      await _pumpSidebar(tester, [
        _buildAndroidDevice('serial-5', state: AndroidDeviceState.device),
      ]);

      expect(find.byIcon(CupertinoIcons.wifi), findsNothing);
      expect(find.byIcon(CupertinoIcons.wifi_slash), findsNothing);
    });

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
