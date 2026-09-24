import 'dart:io';

import 'package:api_adb/adb/adb_api.dart';
import 'package:device_viewer/design/theme/device_viewer_macos_theme.dart';
import 'package:device_viewer/feat_device_canvas/presentation/device_canvas_container.dart';
import 'package:device_viewer/feat_device_connections/data/repositories/device_connections_repository_impl.dart';
import 'package:device_viewer/feat_device_connections/domain/repositories/device_canvas_repository.dart';
import 'package:device_viewer/feat_devices/adb/data/datasources/adb_devices_datasource.dart';
import 'package:device_viewer/feat_devices/adb/data/repositories/adb_devices_repository_impl.dart';
import 'package:device_viewer/feat_devices/adb/data/repositories/dummy_adb_devices_repository.dart';
import 'package:device_viewer/feat_devices/adb/domain/repositories/adb_devices_repository.dart';
import 'package:device_viewer/feat_sidebar/presentation/device_viewer_sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path/path.dart' as path;

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig(
    toolbarStyle: .unified,
  );
  await config.apply();
}

/// Adds a handful of fake devices to the device list so the UI can be
/// tested without needing that many physical devices around.
/// Flip to `false` to only see devices adb actually reports.
const _useDummyDevices = true;

Future<void> main() async {
  await _configureMacosWindowUtils();

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
        RepositoryProvider<AdbDevicesRepository>(
          create: (_) {
            final repository = AdbDevicesRepositoryImpl(
              AdbDevicesDatasource(api: AdbApi(executablePath: adbPath)),
            );

            if (_useDummyDevices) {
              return DummyAdbDevicesRepository(repository);
            }

            return repository;
          },
        ),
        RepositoryProvider<DeviceConnectionsRepository>(
          create: (context) {
            return DeviceConnectionsRepositoryImpl(
              RepositoryProvider.of(context),
            );
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
    return MacosApp(
      title: 'Device Viewer',
      themeMode: .system,
      theme: DeviceViewerMacosTheme.light,
      darkTheme: DeviceViewerMacosTheme.dark,
      debugShowCheckedModeBanner: false,
      home: MacosWindow(
        sidebar: Sidebar(
          minWidth: 200,
          builder: (context, scrollController) {
            return DeviceViewerSidebar(
              scrollController: scrollController,
            );
          },
        ),
        child: _DeviceViewerScreen(),
      ),
    );
  }
}

class const _DeviceViewerScreen() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text("Device Viewer"),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        leading: MacosTooltip(
          message: "Seitenleisten ausblenden/anzeigen",
          child: MacosIconButton(
            onPressed: () {
              MacosWindowScope.of(context).toggleSidebar();
            },
            icon: MacosIcon(CupertinoIcons.sidebar_left, size: 20),
            boxConstraints: const BoxConstraints(
              minWidth: 20,
              minHeight: 20,
              maxWidth: 48,
              maxHeight: 48,
            ),
          ),
        ),
      ),
      children: [
        ContentArea(
          builder: ((context, scrollController) {
            return DeviceCanvasContainer(
              scrollController: scrollController,
            );
          }),
        ),
      ],
    );
  }
}
