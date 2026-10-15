import 'dart:async';

import 'package:api_adb/adb/adb_api.dart';
import 'package:api_devicectl/api_devicectl.dart';
import 'package:app_logger/app_logger.dart';
import 'package:clock/clock.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:synk/feat_clipboard/application/host_clipboard.dart';
import 'package:synk/feat_device_frame/application/file_picker.dart';
import 'package:synk/feat_device_platform/application/device_platform.dart';
import 'package:synk/feat_device_platform_android/android_device_platform.dart';
import 'package:synk/feat_device_platform_android/bundled_files.dart';
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
import 'package:synk/feat_screen_capture_preview/application/system_file_opener.dart';
import 'package:synk/feat_screen_capture_event/application/screen_capture_event_channel.dart';
import 'package:synk/feat_settings/data/repositories/settings_repository_impl.dart';
import 'package:synk/feat_settings/domain/models/settings.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:synk/feat_sidebar/presentation/synk_sidebar.dart';
import 'package:synk/feat_tool_validation/domain/models/adb_paths.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_availability.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';
import 'package:synk/feat_tool_validation/presentation/widgets/tool_issue_message.dart';
import 'package:synk/feat_tool_validation/presentation/widgets/tool_validation_gate.dart';
import 'package:synk/feat_settings/presentation/settings_popover.dart';
import 'package:synk/feat_settings/presentation/settings_shortcut.dart';
import 'package:synk/feat_settings/presentation/settings_window.dart';
import 'package:synk/feat_settings/presentation/theme_mode_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:macos_window_utils/macos_window_utils.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  appLogger = createAppLogger(level: kDebugMode ? Level.debug : Level.info);

  await _configureWindow();

  final preferences = RxSharedPreferences.getInstance();
  final defaults = Settings.defaults(
    screenCaptureSavePath: (await getDownloadsDirectory())!.path,
  );

  final settingsRepository = SettingsRepositoryImpl(
    preferences: preferences,
    defaults: defaults,
  );

  final settings = await settingsRepository.read();
  final platform = NativePlatform.current!;
  const processManager = LocalProcessManager();
  const fileSystem = LocalFileSystem();
  final bundledFiles = BundledFiles(
    bundle: rootBundle,
    fileSystem: fileSystem,
    directory: (await getTemporaryDirectory()).path,
  );
  final adbPaths = AdbPaths(
    bundled: _bundledAdbPath(platform),
    custom: settings.customAdbPath,
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NotificationService>(
          create: (_) => NotificationService(),
          lazy: false,
          dispose: (repository) => repository.dispose(),
        ),
        RepositoryProvider<ScreenCaptureEventChannel>(
          create: (_) => ScreenCaptureEventChannel(),
          lazy: false,
          dispose: (repository) => repository.dispose(),
        ),
        RepositoryProvider<RxSharedPreferences>(
          create: (_) => preferences,
          lazy: false,
          dispose: (repository) => repository.dispose(),
        ),
        RepositoryProvider<SettingsRepository>(
          create: (_) => settingsRepository,
          lazy: false,
        ),
        RepositoryProvider<AdbPaths>.value(value: adbPaths),
        RepositoryProvider<HostClipboard>.value(
          value: const SystemHostClipboard(),
        ),
        RepositoryProvider<FilePicker>.value(value: const SystemFilePicker()),
        RepositoryProvider<FileSystem>.value(value: fileSystem),
        RepositoryProvider<BundledFiles>.value(value: bundledFiles),
        RepositoryProvider<Clock>.value(value: const Clock()),
        RepositoryProvider<NativePlatform>.value(value: platform),
        RepositoryProvider<ProcessManager>.value(value: processManager),
        RepositoryProvider<SystemFileOpener>.value(
          value: SystemFileOpener(
            processManager: processManager,
            platform: platform,
          ),
        ),
      ],
      child: _Root(defaults: defaults),
    ),
  );
}

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

String _bundledAdbPath(NativePlatform platform) {
  return path.normalize(
    path.join(
      path.dirname(platform.resolvedExecutable),
      '..',
      'Resources',
      'adb',
    ),
  );
}

class const _Root({required final Settings defaults}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeModeProvider(
      defaults: defaults,
      builder: (context, themeMode) {
        final SynkUiThemeData theme = switch (themeMode) {
          .light => .light,
          .dark => .dark,
          .system => switch (MediaQuery.platformBrightnessOf(context)) {
            .dark => .dark,
            .light => .light,
          },
        };

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
                  adbPath: RepositoryProvider.of<AdbPaths>(context).active,
                  builder: (context, warnings) {
                    return _ToolProviders(
                      availability: ToolAvailability.fromIssues(warnings),
                      child: _SynkScreen(warnings: warnings),
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

class const _ToolProviders({
  required final ToolAvailability availability,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: availability),
        RepositoryProvider(
          create: (context) => AdbApi(
            adbPath: RepositoryProvider.of<AdbPaths>(context).active,
            processManager: RepositoryProvider.of(context),
          ),
        ),
        RepositoryProvider(
          create: (context) => DevicectlApi(
            processManager: RepositoryProvider.of(context),
          ),
        ),
        RepositoryProvider<DeviceConnectionsRepository>(
          create: (context) => DeviceConnectionsRepositoryImpl(
            platforms: _availablePlatforms(context, availability),
            settingsRepository: RepositoryProvider.of(context),
          ),
          lazy: false,
          dispose: (repository) => repository.dispose(),
        ),
      ],
      child: child,
    );
  }

  List<DevicePlatform> _availablePlatforms(
    BuildContext context,
    ToolAvailability availability,
  ) {
    final platforms = <DevicePlatform>[
      AndroidDevicePlatform(
        RepositoryProvider.of(context),
        bundledFiles: RepositoryProvider.of(context),
        clock: RepositoryProvider.of(context),
      ),
      IosDevicePlatform(
        discoveryChannel: IosDeviceDiscoveryChannel(),
        channel: IosMirrorChannel(),
        mediaStreamChannel: IosMediaStreamChannel(),
        hidChannel: IosHidChannel(),
        devicectl: RepositoryProvider.of(context),
        fileSystem: RepositoryProvider.of(context),
      ),
    ];

    return platforms
        .where(
          (platform) =>
              platform.getRequiredTools().every(availability.isAvailable),
        )
        .toList();
  }
}

class const _SynkScreen({required final List<ToolIssue> warnings})
    extends StatefulWidget {
  @override
  State<_SynkScreen> createState() => _SynkScreenState();
}

class _SynkScreenState extends State<_SynkScreen> {
  var _showSidebar = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reportWarnings());
  }

  void _reportWarnings() {
    if (!mounted) {
      return;
    }

    final notifications = context.read<NotificationService>();
    for (final warning in widget.warnings) {
      notifications.notify(
        AppNotification(
          message: warning.message,
          severity: NotificationSeverity.critical,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsShortcut(
      onInvoke: () => unawaited(showSettingsWindow(context)),
      child: SynkUiShell(
        title: 'Synk',
        showSidebar: _showSidebar,
        leading: SynkUiTooltip(
          message: 'Seitenleiste ausblenden/anzeigen',
          child: SynkUiIconButton(
            icon: CupertinoIcons.sidebar_left,
            onPressed: () => setState(() => _showSidebar = !_showSidebar),
          ),
        ),
        actions: const [SettingsPopover()],
        sidebar: const SynkSidebar(),
        child: const DeviceCanvasContainer(),
      ),
    );
  }
}
