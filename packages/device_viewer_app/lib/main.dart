import 'dart:io';

import 'package:api_adb/adb/adb_api.dart';
import 'package:app_logger/app_logger.dart';
import 'package:device_viewer/feat_device_agent/data/repositories/android_device_agent_repository_impl.dart';
import 'package:device_viewer/feat_device_canvas/presentation/device_canvas_container.dart';
import 'package:device_viewer/feat_device_connections/data/repositories/device_connections_repository_impl.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:device_viewer/feat_plugged_devices/adb/data/datasources/adb_devices_datasource.dart';
import 'package:device_viewer/feat_plugged_devices/adb/data/repositories/plugged_adb_devices_repository_impl.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/repositories/plugged_adb_devices_repository.dart';
import 'package:device_viewer/feat_notifications/application/notification_service.dart';
import 'package:device_viewer/feat_notifications/presentation/app_notification_listener.dart';
import 'package:device_viewer/feat_sidebar/presentation/device_viewer_sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bench_ui/bench_ui.dart';
import 'package:macos_window_utils/macos_window_utils.dart';
import 'package:path/path.dart' as path;

Future<void> _configureWindow() async {
  await WindowManipulator.initialize();
  await WindowManipulator.makeTitlebarTransparent();
  await WindowManipulator.enableFullSizeContentView();
  await WindowManipulator.hideTitle();
  await WindowManipulator.addToolbar();
  await WindowManipulator.setToolbarStyle(
    toolbarStyle: NSWindowToolbarStyle.unified,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  appLogger = createAppLogger(
    level: kDebugMode ? Level.debug : Level.info,
  );

  await _configureWindow();

  final adbPath = path.normalize(
    path.join(
      path.dirname(Platform.resolvedExecutable),
      '..',
      'Resources',
      'adb',
    ),
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NotificationService>(
          create: (context) => NotificationService(),
          lazy: false,
          dispose: (service) => service.dispose(),
        ),
        RepositoryProvider.value(value: AdbApi(adbPath: adbPath)),
        RepositoryProvider<PluggedAdbDevicesRepository>(
          create: (context) {
            return PluggedAdbDevicesRepositoryImpl(
              AdbDevicesDatasource(
                api: RepositoryProvider.of(context),
              ),
            );
          },
          lazy: false,
        ),
        RepositoryProvider<DeviceConnectionsRepository>(
          create: (context) {
            return DeviceConnectionsRepositoryImpl(
              pluggedAdbDevicesRepository: RepositoryProvider.of(context),
              agentRepository: AndroidDeviceAgentRepositoryImpl(
                RepositoryProvider.of(context),
              ),
            );
          },
          lazy: false,
          dispose: (repository) {
            repository.dispose();
          },
        ),
      ],
      child: const _DeviceViewerApp(),
    ),
  );
}

class const _DeviceViewerApp() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Device Viewer',
      color: const BenchColors.dark().accent,
      debugShowCheckedModeBanner: false,
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        );
      },
      home: const _Root(),
    );
  }
}

class const _Root() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = BenchThemeData.forBrightness(
      MediaQuery.platformBrightnessOf(context),
    );

    return BenchTheme(
      data: theme,
      child: DefaultTextStyle(
        style: theme.type.body,
        child: AppNotificationListener(
          notifications: RepositoryProvider.of<NotificationService>(context),
          child: const _DeviceViewerScreen(),
        ),
      ),
    );
  }
}

class const _DeviceViewerScreen() extends StatefulWidget {
  @override
  State<_DeviceViewerScreen> createState() => _DeviceViewerScreenState();
}

class _DeviceViewerScreenState extends State<_DeviceViewerScreen> {
  var _showSidebar = true;

  @override
  Widget build(BuildContext context) {
    return BenchShell(
      title: 'Device Viewer',
      showSidebar: _showSidebar,
      leading: BenchTooltip(
        message: 'Seitenleiste ausblenden/anzeigen',
        child: BenchIconButton(
          icon: CupertinoIcons.sidebar_left,
          onPressed: () => setState(() => _showSidebar = !_showSidebar),
        ),
      ),
      sidebar: const DeviceViewerSidebar(),
      child: const DeviceCanvasContainer(),
    );
  }
}
