import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:device_viewer/design/widgets/reflow_grid.dart';
import 'package:device_viewer/feat_device_canvas/data/repositories/device_canvas_repository_impl.dart';
import 'package:device_viewer/feat_device_canvas/domain/models/canvas_device.dart';
import 'package:device_viewer/feat_device_canvas/presentation/bloc/device_canvas_bloc.dart';
import 'package:device_viewer/feat_device_canvas/presentation/widgets/device_frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          RepositoryProvider.of(context),
        ),
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
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ReflowGrid<CanvasDevice>(
        scrollController: scrollController,
        padding: DeviceViewerTheme.pagePadding,
        mainAxisSpacing: DeviceViewerTheme.verticalComponentSpacingMedium,
        crossAxisSpacing: DeviceViewerTheme.horizontalComponentSpacingMedium,
        items: state.devices,
        crossAxisCount: 4,
        // Placeholder for an actual per-device value until we read the real
        // screen resolution via adb (e.g. `wm size`) — a typical portrait
        // phone ratio reads much better here than a square.
        childAspectRatio: 9 / 19.5,
        duration: const Duration(milliseconds: 150),
        keyOf: (item) => item.device.id,
        itemBuilder: (context, item) {
          return DeviceFrame(
            device: item,
            onCaptureScreenshot: (device) {
              BlocProvider.of<DeviceCanvasBloc>(context)
                  .add(DeviceCanvasEvent.onCaptureScreenshot(device));
            },
          );
        },
      ),
    );
  }
}
