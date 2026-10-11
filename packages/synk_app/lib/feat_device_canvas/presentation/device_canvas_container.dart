import 'dart:async';

import 'package:synk/design/theme/synk_theme.dart';
import 'package:synk/design/widgets/reflow_grid.dart';
import 'package:synk/feat_device_canvas/data/repositories/device_canvas_repository_impl.dart';
import 'package:synk/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:synk/feat_device_canvas/presentation/bloc/device_canvas_bloc.dart';
import 'package:synk/feat_device_frame/presentation/device_frame.dart';
import 'package:synk/feat_maximized_device/domain/models/maximized_device.dart';
import 'package:synk/feat_maximized_device/presentation/maximized_device_screen.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const DeviceCanvasContainer({super.key}) extends StatelessWidget {
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
      child: const _MaximizableCanvas(),
    );
  }
}

class const _MaximizableCanvas() extends StatefulWidget {
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
    final maximizedDevice = MaximizedDevice(
      deviceId: device.device.id,
      modelName: device.device.modelName,
      textureId: device.textureId,
      screenSize: device.screenSize,
      supportsInteraction: device.supportsInteraction,
      supportsDeviceActions: device.supportsDeviceActions,
      supportsAudio: device.supportsAudio,
    );

    final route = PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: false,
      transitionDuration: SynkTheme.maximizeTransitionDuration,
      reverseTransitionDuration: SynkTheme.maximizeTransitionDuration,
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
  required final DeviceCanvasState state,
  required final MaximizeCallback onMaximize,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: state.devices.isEmpty
          ? const _NoDevicesMirrored()
          : _buildGrid(context),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ReflowGrid<CanvasDevice>(
        padding: SynkTheme.pagePadding,
        mainAxisSpacing: SynkTheme.verticalComponentSpacingMedium,
        crossAxisSpacing: SynkTheme.horizontalComponentSpacingMedium,
        items: state.devices,
        cellSizeOf: (item) => deviceFrameSizeFor(item.screenSize),
        duration: const Duration(milliseconds: 150),
        keyOf: (item) => item.device.id,
        itemBuilder: (context, item) {
          return DeviceFrame(
            deviceId: item.device.id,
            modelName: item.device.modelName,
            textureId: item.textureId,
            screenSize: item.screenSize,
            supportsInteraction: item.supportsInteraction,
            supportsDeviceActions: item.supportsDeviceActions,
            supportsAudio: item.supportsAudio,
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
    return const SynkUiEmptyState(
      icon: CupertinoIcons.rectangle_stack,
      title: 'Keine Geräte aktiv',
      message: 'Wähle links ein Gerät aus und klicke auf „Verbinden".',
    );
  }
}
