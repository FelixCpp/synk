import 'dart:io';

import 'package:api_adb/adb/adb_api.dart';
import 'package:api_devicectl/api_devicectl.dart';
import 'package:app_logger/app_logger.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:synk/feat_device_platform/application/device_platform.dart';
import 'package:synk/feat_device_platform_android/android_device_platform.dart';
import 'package:synk/feat_device_platform_ios/discovery/ios_device_discovery_channel.dart';
import 'package:synk/feat_device_platform_ios/hid/ios_hid_channel.dart';
import 'package:synk/feat_device_platform_ios/ios_device_platform.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_media_stream_channel.dart';
import 'package:synk/feat_device_platform_ios/mirror/ios_mirror_channel.dart';
import 'package:synk/feat_device_canvas/presentation/device_canvas_container.dart';
import 'package:synk/feat_device_connections/data/repositories/device_connections_repository_impl.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_notifications/presentation/app_notification_listener.dart';
import 'package:synk/feat_notifications/domain/models/app_notification.dart';
import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';
import 'package:synk/feat_settings/data/repositories/settings_repository_impl.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:synk/feat_sidebar/presentation/synk_sidebar.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_availability.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';
import 'package:synk/feat_tool_validation/presentation/widgets/tool_issue_message.dart';
import 'package:synk/feat_tool_validation/presentation/widgets/tool_validation_gate.dart';
import 'package:synk/feat_settings/domain/models/theme_mode.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';
import 'package:synk/feat_settings/presentation/theme_mode_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:macos_window_utils/macos_window_utils.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

const _defaultThemeMode = ThemeMode.light;

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

  final defaultScreenCaptureSavePath = (await getDownloadsDirectory())!.path;

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NotificationService>(
          create: (context) => NotificationService(),
          lazy: false,
          dispose: (repository) => repository.dispose(),
        ),
        RepositoryProvider<ScreenCaptureEventChannel>(
          create: (_) => ScreenCaptureEventChannel(),
          lazy: false,
          dispose: (repository) => repository.dispose(),
        ),
        RepositoryProvider<RxSharedPreferences>(
          create: (_) => RxSharedPreferences.getInstance(),
          lazy: false,
          dispose: (repository) => repository.dispose(),
        ),
        RepositoryProvider<SettingsRepository>(
          create: (context) => SettingsRepositoryImpl(
            preferences: RepositoryProvider.of(context),
            fallbackScreenCaptureSavePath: defaultScreenCaptureSavePath,
            fallbackThemeMode: _defaultThemeMode,
          ),
          lazy: false,
        ),
      ],
      child: _Root(adbPath: adbPath),
    ),
  );
}

class const _ToolProviders({
  required final String adbPath,
  required final ToolAvailability availability,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: availability),
        RepositoryProvider(create: (context) => AdbApi(adbPath: adbPath)),
        RepositoryProvider(create: (context) => DevicectlApi()),
        RepositoryProvider<DeviceConnectionsRepository>(
          create: (context) {
            final platforms = <DevicePlatform>[
              AndroidDevicePlatform(RepositoryProvider.of(context)),
              IosDevicePlatform(
                discoveryChannel: IosDeviceDiscoveryChannel(),
                channel: IosMirrorChannel(),
                mediaStreamChannel: IosMediaStreamChannel(),
                hidChannel: IosHidChannel(),
                devicectl: RepositoryProvider.of(context),
              ),
            ];

            return DeviceConnectionsRepositoryImpl(
              platforms: [
                for (final platform in platforms)
                  if (platform.getToolRequirements().every(
                    availability.isAvailable,
                  ))
                    platform,
              ],
            );
          },
          lazy: false,
          dispose: (repository) {
            repository.dispose();
          },
        ),
      ],
      child: child,
    );
  }
}

class const _Root({required final String adbPath}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeModeProvider(
      initialThemeMode: _defaultThemeMode,
      builder: (context, themeMode) {
        final theme = SynkUiThemeData.forBrightness(themeMode);

        return SynkUiTheme(
          data: theme,
          child: DefaultTextStyle(
            style: theme.typography.body,
            child: WidgetsApp(
              title: 'Synk',
              color: theme.colors.accent,
              debugShowCheckedModeBanner: false,
              pageRouteBuilder: <T>(settings, builder) {
                return PageRouteBuilder<T>(
                  settings: settings,
                  pageBuilder: (context, _, _) => builder(context),
                );
              },
              home: AppNotificationListener(
                notifications: RepositoryProvider.of<NotificationService>(
                  context,
                ),
                child: ToolValidationGate(
                  adbPath: adbPath,
                  builder: (context, warnings) {
                    return _ToolProviders(
                      adbPath: adbPath,
                      availability: ToolAvailability.fromIssues(warnings),
                      child: _SynkScreen(
                        themeMode: themeMode,
                        warnings: warnings,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class const _SynkScreen({
  required final ThemeMode themeMode,
  required final List<ToolIssue> warnings,
}) extends StatefulWidget {
  @override
  State<_SynkScreen> createState() => _SynkScreenState();
}

class _SynkScreenState extends State<_SynkScreen> {
  var _showSidebar = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final notifications = context.read<NotificationService>();
      for (final warning in widget.warnings) {
        notifications.notify(
          AppNotification(
            message: warning.message,
            severity: NotificationSeverity.critical,
          ),
        );
      }
    });
  }

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
            onPressed: () => context.read<SettingsBloc>().add(
              .onSetThemeMode(widget.themeMode.inverted()),
            ),
          ),
        ),
      ],
      sidebar: const SynkSidebar(),
      child: const DeviceCanvasContainer(),
    );
  }
}
