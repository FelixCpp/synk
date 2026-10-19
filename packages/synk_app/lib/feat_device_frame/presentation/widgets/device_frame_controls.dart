import 'package:synk/feat_device_frame/presentation/bloc/device_frame_bloc.dart';
import 'package:synk/feat_device_frame/presentation/device_frame_metrics.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The navigation strip below a mirrored screen.
///
/// Shows only what the device says it supports, and asks the bloc directly —
/// there is nothing here the frame above needs to decide.
class const DeviceFrameControls({
  super.key,
  required final Set<DeviceNavigation> navigations,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: DeviceFrameMetrics.controlsBarHeight,
      child: Padding(
        padding: DeviceFrameMetrics.controlsBarPadding,
        child: ColoredBox(
          color: context.synkUi.colors.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: SynkUiSpace.s4),
            child: Row(
              mainAxisAlignment: .spaceEvenly,
              children: [
                for (final navigation in DeviceNavigation.values)
                  if (navigations.contains(navigation))
                    _NavigationButton(navigation: navigation),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class const _NavigationButton({
  required final DeviceNavigation navigation,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final (:icon, :iconSize, :tooltip) = switch (navigation) {
      .back => (
        icon: CupertinoIcons.back,
        iconSize: 22.0,
        tooltip: 'Zurück',
      ),
      .home => (
        icon: CupertinoIcons.home,
        iconSize: 20.0,
        tooltip: 'Home',
      ),
      .appSwitch => (
        icon: CupertinoIcons.line_horizontal_3,
        iconSize: 22.0,
        tooltip: 'Übersicht',
      ),
    };

    return SynkUiTooltip(
      message: tooltip,
      child: SynkUiIconButton(
        icon: icon,
        size: 38.0,
        iconSize: iconSize,
        onPressed: () =>
            context.read<DeviceFrameBloc>().add(.onNavigate(navigation)),
      ),
    );
  }
}
