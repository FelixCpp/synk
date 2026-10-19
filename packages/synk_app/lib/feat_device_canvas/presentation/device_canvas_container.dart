import 'dart:async';

import 'package:synk/design/widgets/reflow_grid.dart';
import 'package:synk/feat_device_canvas/presentation/bloc/device_canvas_bloc.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_device_connections/domain/repositories/device_connections_repository.dart';
import 'package:synk/feat_device_frame/presentation/device_frame.dart';
import 'package:synk/feat_device_frame/presentation/device_frame_metrics.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_maximized_device/presentation/maximized_device_metrics.dart';
import 'package:synk/feat_maximized_device/presentation/maximized_device_screen.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_screen_capture_preview/presentation/screen_capture_preview_thumbnail.dart';
import 'package:synk/feat_settings/domain/models/settings.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const DeviceCanvasContainer({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeviceCanvasBloc>(
      create: (context) => DeviceCanvasBloc(
        RepositoryProvider.of<DeviceConnectionsRepository>(context),
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

  Future<void> _openMaximized(
    BuildContext context,
    DeviceConnection device,
  ) async {
    final route = PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: false,
      transitionDuration: MaximizedDeviceMetrics.transitionDuration,
      reverseTransitionDuration: MaximizedDeviceMetrics.transitionDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return MaximizedDeviceScreen(
          device: device,
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

typedef MaximizeCallback = void Function(DeviceConnection device);

class const _Content({
  required final DeviceCanvasState state,
  required final MaximizeCallback onMaximize,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: .opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: state.devices.isEmpty
          ? const _NoDevicesMirrored()
          : _buildGrid(context),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context)
                .copyWith(scrollbars: false),
            child: ReflowGrid<DeviceConnection>(
              padding: SynkUiInsets.page,
              mainAxisSpacing: SynkUiSpace.s8,
              crossAxisSpacing: SynkUiSpace.s8,
              items: state.devices,
              cellSizeOf: (item) =>
                  DeviceFrameMetrics.sizeFor(item.screenSize.aspectRatio),
              duration: const Duration(milliseconds: 150),
              keyOf: (item) => item.device.id,
              itemBuilder: (context, item) {
                return DeviceFrame(
                  connection: item,
                  isMaximized: false,
                  onToggleMaximize: () => onMaximize(item),
                  onClose: () {
                    BlocProvider.of<DeviceCanvasBloc>(context)
                        .add(.onCloseDevice(item));
                  },
                );
              },
            ),
          ),
        ),
        Align(
          alignment: .bottomRight,
          child: Padding(
            padding: SynkUiInsets.card,
            child: BlocSelector<SettingsBloc, Settings, bool>(
              selector: (settings) => settings.showCapturePreview,
              builder: (context, showPreview) => showPreview
                  ? const ScreenCapturePreviewThumbnail()
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
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
