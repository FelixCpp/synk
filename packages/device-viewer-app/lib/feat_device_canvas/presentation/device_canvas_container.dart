import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:device_viewer/feat_device_canvas/data/repositories/device_canvas_repository_impl.dart';
import 'package:device_viewer/feat_device_canvas/presentation/bloc/device_canvas_bloc.dart';
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
    return AnimatedReorderableGridView(
      items: state.devices,
      itemBuilder: (context, index) {
        final item = state.devices[index];
        return SizedBox.expand(
          child: Container(
            color: MacosColors.systemRedColor,
            child: Center(child: Text(item.device.id)),
          ),
        );
      },
      sliverGridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      onReorder: (oldIndex, newIndex) {},
      isSameItem: (a, b) => a.device.id == b.device.id,
    );
  }
}
