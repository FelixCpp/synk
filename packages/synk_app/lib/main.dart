import 'dart:io';

import 'package:api_adb/adb/adb_api.dart';
import 'package:app_logger/app_logger.dart';
import 'package:synk/feat_device_agent/data/datasources/ios_mirror_channel.dart';
import 'package:synk/feat_device_agent/data/repositories/android_device_agent_repository_impl.dart';
import 'package:synk/feat_device_agent/data/repositories/ios_device_agent_repository_impl.dart';
import 'package:synk/feat_device_canvas/presentation/device_canvas_container.dart';
import 'package:synk/feat_device_connections/data/repositories/device_connections_repository_impl.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_plugged_devices/adb/data/datasources/adb_devices_datasource.dart';
import 'package:synk/feat_plugged_devices/adb/data/repositories/plugged_adb_devices_repository_impl.dart';
import 'package:synk/feat_plugged_devices/adb/domain/repositories/plugged_adb_devices_repository.dart';
import 'package:synk/feat_plugged_devices/ios/data/datasources/ios_device_discovery_channel.dart';
import 'package:synk/feat_plugged_devices/ios/data/repositories/plugged_ios_devices_repository_impl.dart';
import 'package:synk/feat_plugged_devices/ios/domain/repositories/plugged_ios_devices_repository.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_notifications/presentation/app_notification_listener.dart';
import 'package:synk/feat_sidebar/presentation/synk_sidebar.dart';
import 'package:synk/feat_theme_mode/domain/models/theme_mode.dart';
import 'package:synk/feat_theme_mode/presentation/bloc/theme_mode_bloc.dart';
import 'package:synk/feat_theme_mode/presentation/theme_mode_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synk_ui/synk_ui.dart';
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
        RepositoryProvider<PluggedIosDevicesRepository>(
          create: (context) {
            return PluggedIosDevicesRepositoryImpl(IosDeviceDiscoveryChannel());
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
              pluggedIosDevicesRepository: RepositoryProvider.of(context),
              iosAgentRepository: IosDeviceAgentRepositoryImpl(
                IosMirrorChannel(),
              ),
            );
          },
          lazy: false,
          dispose: (repository) {
            repository.dispose();
          },
        ),
      ],
      child: const _Root(),
    ),
  );
}

class const _Root() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeModeProvider(
      builder: (context, state) {
        final theme = SynkUiThemeData.forBrightness(state.themeMode);

        return SynkUiTheme(
          data: theme,
          child: DefaultTextStyle(
            style: theme.typography.body,
            child: _SynkApp(themeMode: state.themeMode),
          ),
        );
      },
    );
  }
}

class const _SynkApp({required final ThemeMode themeMode})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Synk',
      color: const SynkUiColors.dark().accent,
      debugShowCheckedModeBanner: false,
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        );
      },
      home: AppNotificationListener(
        notifications: RepositoryProvider.of<NotificationService>(context),
        child: _SynkScreen(themeMode: themeMode),
      ),
    );
  }
}

class const _SynkScreen({
  required final ThemeMode themeMode,
}) extends StatefulWidget {
  @override
  State<_SynkScreen> createState() => _SynkScreenState();
}

class _SynkScreenState extends State<_SynkScreen> {
  var _showSidebar = true;

  @override
  Widget build(BuildContext context) {
    return SynkUiShell(
      title: 'Synk',
      showSidebar: _showSidebar,
      leading: SynkUiTooltip(
        message: 'Seitenleiste ausblenden/anzeigen',
        child: SynkUiIconButton(
          icon: CupertinoIcons.sidebar_left,
          onPressed: () => setState(() => _showSidebar = !_showSidebar),
        ),
      ),
      actions: [
        SynkUiTooltip(
          message: widget.themeMode == .dark
              ? 'Helles Design aktivieren'
              : 'Dunkles Design aktivieren',
          child: SynkUiIconButton(
            icon: widget.themeMode == .dark
                ? CupertinoIcons.sun_max
                : CupertinoIcons.moon,
            onPressed: () => context.read<ThemeModeBloc>().add(
              const .onToggleThemeMode(),
            ),
          ),
        ),
      ],
      sidebar: const SynkSidebar(),
      child: const DeviceCanvasContainer(),
    );
  }
}
