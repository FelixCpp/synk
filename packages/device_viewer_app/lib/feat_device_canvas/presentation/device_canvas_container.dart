import 'package:device_viewer/design/build_context.dart';
import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:device_viewer/design/widgets/reflow_grid.dart';
import 'package:device_viewer/feat_device_canvas/data/repositories/device_canvas_repository_impl.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_canvas/presentation/bloc/device_canvas_bloc.dart';
import 'package:device_viewer/feat_device_canvas/presentation/widgets/device_frame.dart';
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
      child: BlocBuilder<DeviceCanvasBloc, DeviceCanvasState>(
        builder: (context, state) {
          return _Content(
            scrollController: scrollController,
            state: state,
          );
        },
      ),
    );
  }
}

class const _Content({
  required final ScrollController scrollController,
  required final DeviceCanvasState state,
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
            device: item,
            onCaptureScreenshot: (device) {
              BlocProvider.of<DeviceCanvasBloc>(context)
                  .add(DeviceCanvasEvent.onCaptureScreenshot(device));
            },
            onClose: (device) {
              BlocProvider.of<DeviceCanvasBloc>(context)
                  .add(DeviceCanvasEvent.onCloseDevice(device));
            },
            onTouch: (device, actionId, x, y) {
              BlocProvider.of<DeviceCanvasBloc>(context).add(
                DeviceCanvasEvent.onDeviceTapped(
                  device: device,
                  action: actionId,
                  normalizedX: x,
                  normalizedY: y,
                ),
              );
            },
            mirrorTextureId: item.when(
              android: (device, isConnected, textureId, screenSize) =>
                  textureId,
              connecting: (device) => null,
            ),
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
