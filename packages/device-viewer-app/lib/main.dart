import 'package:api_adb/adb/adb_api.dart';
import 'package:device_viewer/feat_device_canvas/presentation/device_canvas_container.dart';
import 'package:device_viewer/feat_devices/adb/data/datasources/adb_devices_datasource.dart';
import 'package:device_viewer/feat_devices/adb/data/repositories/adb_devices_repository_impl.dart';
import 'package:device_viewer/feat_devices/adb/domain/repositories/adb_devices_repository.dart';
import 'package:device_viewer/feat_sidebar/presentation/device_viewer_sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig(
    toolbarStyle: .unified,
  );
  await config.apply();
}

Future<void> main() async {
  await _configureMacosWindowUtils();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AdbDevicesRepository>(
          create: (_) => AdbDevicesRepositoryImpl(
            AdbDevicesDatasource(api: AdbApi(executablePath: 'adb')),
          ),
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
      themeMode: .light,
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
