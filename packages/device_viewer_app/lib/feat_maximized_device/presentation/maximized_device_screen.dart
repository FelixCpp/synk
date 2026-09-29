import 'dart:ui';

import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:device_viewer/feat_device_frame/presentation/device_frame.dart';
import 'package:device_viewer/feat_maximized_device/data/repositories/maximized_device_repository_impl.dart';
import 'package:device_viewer/feat_maximized_device/domain/models/maximized_device.dart';
import 'package:device_viewer/feat_maximized_device/presentation/bloc/maximized_device_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

class const MaximizedDeviceScreen({
  super.key,
  required final MaximizedDevice device,
  required final Animation<double> animation,
  required final VoidCallback onStopMirroring,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MaximizedDeviceBloc(
        device: device,
        repository: MaximizedDeviceRepositoryImpl(
          connectionsRepository: RepositoryProvider.of(context),
        ),
      ),
      child: BlocConsumer<MaximizedDeviceBloc, MaximizedDeviceState>(
        listenWhen: (previous, current) => !previous.isGone && current.isGone,
        listener: (context, state) {
          Navigator.of(context).pop();
        },
        builder: (context, state) {
          return _Content(
            device: state.device,
            animation: animation,
            onClose: onStopMirroring,
          );
        },
      ),
    );
  }
}

class const _Content({
  required final MaximizedDevice device,
  required final Animation<double> animation,
  required final VoidCallback onClose,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void minimize() {
      Navigator.of(context).pop();
    }

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: minimize,
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                final t = Curves.easeOutCubic.transform(
                  animation.value.clamp(0.0, 1.0),
                );
                final blur = DeviceViewerTheme.maximizeBackdropBlur * t;

                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: ColoredBox(
                    color: MacosColors.black.withAlpha(
                      (DeviceViewerTheme.maximizeScrimAlpha * t).round(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: DeviceViewerTheme.maximizeDevicePadding,
            child: DeviceFrame(
              deviceId: device.deviceId,
              modelName: device.modelName,
              isLive: device.isLive,
              textureId: device.textureId,
              screenSize: device.screenSize,
              isMaximized: true,
              onToggleMaximize: minimize,
              onClose: onClose,
              onEscape: minimize,
            ),
          ),
        ),
      ],
    );
  }
}
