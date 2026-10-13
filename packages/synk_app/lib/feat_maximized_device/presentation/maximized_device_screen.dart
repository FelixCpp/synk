import 'dart:ui';

import 'package:synk/design/theme/synk_theme.dart';
import 'package:synk/feat_device_frame/presentation/device_frame.dart';
import 'package:synk/feat_device_connections/domain/models/device_connection.dart';
import 'package:synk/feat_maximized_device/data/repositories/maximized_device_repository.dart';
import 'package:synk/feat_maximized_device/presentation/bloc/maximized_device_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const MaximizedDeviceScreen({
  super.key,
  required final DeviceConnection device,
  required final Animation<double> animation,
  required final VoidCallback onStopMirroring,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MaximizedDeviceBloc(
        device: device,
        repository: MaximizedDeviceRepository(
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
  required final DeviceConnection device,
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
                final blur = SynkTheme.maximizeBackdropBlur * t;

                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: ColoredBox(
                    color: const Color(0xFF000000).withAlpha(
                      (SynkTheme.maximizeScrimAlpha * t).round(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: SynkTheme.maximizeDevicePadding,
            child: DeviceFrame(
              connection: device,
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
