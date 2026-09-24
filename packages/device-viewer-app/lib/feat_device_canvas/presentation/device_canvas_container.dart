import 'package:device_viewer/feat_device_canvas/data/repositories/device_canvas_repository_impl.dart';
import 'package:device_viewer/feat_device_canvas/presentation/bloc/device_canvas_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const DeviceCanvasContainer({
  super.key,
  required final ScrollController scrollController,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeviceCanvasBloc>(
      create: (context) => DeviceCanvasBloc(DeviceCanvasRepositoryImpl()),
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
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          const Text("Ich bin hier123"),
        ],
      ),
    );
  }
}
