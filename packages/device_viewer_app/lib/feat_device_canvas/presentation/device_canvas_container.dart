import 'dart:async';

import 'package:device_viewer/design/build_context.dart';
import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:device_viewer/design/widgets/reflow_grid.dart';
import 'package:device_viewer/feat_device_canvas/data/repositories/device_canvas_repository_impl.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_canvas/presentation/bloc/device_canvas_bloc.dart';
import 'package:device_viewer/feat_device_frame/presentation/device_frame.dart';
import 'package:device_viewer/feat_maximized_device/domain/models/maximized_device.dart';
import 'package:device_viewer/feat_maximized_device/presentation/maximized_device_screen.dart';
import 'package:device_viewer/feat_notifications/application/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

class const DeviceCanvasContainer({
  super.key,
  required final ScrollController scrollController,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeviceCanvasBloc>(
      create: (context) => DeviceCanvasBloc(
        DeviceCanvasRepositoryImpl(
          RepositoryProvider.of(context),
        ),
        RepositoryProvider.of(context),
        RepositoryProvider.of<NotificationService>(context),
      ),
      child: _MaximizableCanvas(scrollController: scrollController),
    );
  }
}

class const _MaximizableCanvas({
  required final ScrollController scrollController,
}) extends StatefulWidget {
  @override
  State<_MaximizableCanvas> createState() => _MaximizableCanvasState();
}

class _MaximizableCanvasState extends State<_MaximizableCanvas> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _heroController = HeroController();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      observers: [_heroController],
      onGenerateRoute: (settings) {
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          pageBuilder: (context, animation, secondaryAnimation) {
            return BlocBuilder<DeviceCanvasBloc, DeviceCanvasState>(
              builder: (context, state) {
                return _Content(
                  scrollController: widget.scrollController,
                  state: state,
                  onMaximize: (device) => _openMaximized(context, device),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _openMaximized(BuildContext context, CanvasDevice device) async {
    final maximizedDevice = device.when(
      android: (device, isConnected, textureId, screenSize) => MaximizedDevice(
        deviceId: device.id,
        modelName: device.modelName,
        isLive: isConnected,
        textureId: textureId,
        screenSize: screenSize,
      ),
      connecting: (device) => MaximizedDevice(
        deviceId: device.id,
        modelName: device.modelName,
        isLive: false,
        textureId: null,
        screenSize: null,
      ),
    );

    final route = PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: false,
      transitionDuration: DeviceViewerTheme.maximizeTransitionDuration,
      reverseTransitionDuration: DeviceViewerTheme.maximizeTransitionDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return MaximizedDeviceScreen(
          device: maximizedDevice,
          animation: animation,
          onStopMirroring: () {
            BlocProvider.of<DeviceCanvasBloc>(this.context)
                .add(DeviceCanvasEvent.onCloseDevice(device));
          },
        );
      },
    );

    unawaited(Navigator.of(context).push(route));
  }
}

typedef MaximizeCallback = void Function(CanvasDevice device);

class const _Content({
  required final ScrollController scrollController,
  required final DeviceCanvasState state,
  required final MaximizeCallback onMaximize,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (state.devices.isEmpty) return const _NoDevicesMirrored();

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ReflowGrid<CanvasDevice>(
        scrollController: scrollController,
        padding: DeviceViewerTheme.pagePadding,
        mainAxisSpacing: DeviceViewerTheme.verticalComponentSpacingMedium,
        crossAxisSpacing: DeviceViewerTheme.horizontalComponentSpacingMedium,
        items: state.devices,
        cellWidth: DeviceViewerTheme.deviceFrameWidth,
        cellHeight: DeviceViewerTheme.deviceFrameHeight,
        duration: const Duration(milliseconds: 150),
        keyOf: (item) => item.device.id,
        itemBuilder: (context, item) {
          return DeviceFrame(
            deviceId: item.device.id,
            modelName: item.device.modelName,
            isLive: item.when(
              android: (device, isConnected, textureId, screenSize) =>
                  isConnected,
              connecting: (device) => false,
            ),
            textureId: item.when(
              android: (device, isConnected, textureId, screenSize) =>
                  textureId,
              connecting: (device) => null,
            ),
            screenSize: item.when(
              android: (device, isConnected, textureId, screenSize) =>
                  screenSize,
              connecting: (device) => null,
            ),
            isMaximized: false,
            onToggleMaximize: () => onMaximize(item),
            onClose: () {
              BlocProvider.of<DeviceCanvasBloc>(context)
                  .add(.onCloseDevice(item));
            },
          );
        },
      ),
    );
  }
}

class const _NoDevicesMirrored() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: .min,
          spacing: DeviceViewerTheme.verticalComponentSpacingLarge,
          children: [
            MacosIcon(
              CupertinoIcons.rectangle_stack,
              size: 44.0,
              color: context.colors.secondaryLabel,
            ),
            Text(
              "Keine Gerät aktiv",
              style: context.typo.title3.copyWith(
                color: context.colors.label,
              ),
            ),
            Text(
              "Wähle links ein Gerät aus und tippe auf „Verbinden“.",
              textAlign: .center,
              style: context.typo.body.copyWith(
                color: context.colors.secondaryLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
