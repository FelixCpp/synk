import 'package:device_viewer/design/build_context.dart';
import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:device_viewer/feat_plugged_devices/domain/models/device_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class const DeviceFrameToolBar({
  super.key,
  required final DeviceId deviceId,
  required final String modelName,
  required final bool isLive,
  required final bool isMaximized,
  required final bool areActionsVisible,
  required final VoidCallback onCaptureScreenshot,
  required final VoidCallback onToggleMaximize,
  required final VoidCallback onClose,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.card,
        border: .symmetric(
          horizontal: BorderSide(
            color: context.colors.divider,
            width: DeviceViewerTheme.hairlineThickness,
          ),
        ),
      ),
      child: Padding(
        padding: DeviceViewerTheme.deviceFrameToolBarPadding,
        child: Row(
          spacing: DeviceViewerTheme.horizontalComponentSpacingSmall,
          children: [
            _StatusDot(isLive: isLive),
            Expanded(
              child: MacosTooltip(
                message: deviceId,
                child: Align(
                  alignment: .centerLeft,
                  child: Text(
                    modelName,
                    style: context.typo.headline,
                    overflow: .ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            _Actions(
              isMaximized: isMaximized,
              areActionsVisible: areActionsVisible,
              onCaptureScreenshot: onCaptureScreenshot,
              onToggleMaximize: onToggleMaximize,
              onClose: onClose,
            ),
          ],
        ),
      ),
    );
  }
}

class const _Actions({
  required final bool isMaximized,
  required final bool areActionsVisible,
  required final VoidCallback onCaptureScreenshot,
  required final VoidCallback onToggleMaximize,
  required final VoidCallback onClose,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !areActionsVisible,
      child: AnimatedOpacity(
        duration: DeviceViewerTheme.actionRevealDuration,
        curve: Curves.easeOut,
        opacity: areActionsVisible ? 1.0 : 0.0,
        child: MacosIconTheme(
          data: MacosIconThemeData(
            color: context.colors.label,
            size: 18.0,
          ),
          child: Row(
            children: [
              // TODO(Felix): wire up recording the mirrored stream to a file.
              MacosTooltip(
                message: 'Aufnahme starten',
                child: MacosIconButton(
                  onPressed: () {},
                  icon: MacosIcon(CupertinoIcons.video_camera),
                ),
              ),
              MacosTooltip(
                message: 'Screenshot aufnehmen',
                child: MacosIconButton(
                  onPressed: onCaptureScreenshot,
                  icon: MacosIcon(CupertinoIcons.camera),
                ),
              ),
              MacosTooltip(
                message: isMaximized
                    ? 'Vollbild verlassen'
                    : 'Gerät maximieren',
                child: MacosIconButton(
                  onPressed: onToggleMaximize,
                  icon: MacosIcon(
                    isMaximized
                        ? CupertinoIcons.arrow_down_right_arrow_up_left
                        : CupertinoIcons.arrow_up_left_arrow_down_right,
                  ),
                ),
              ),
              MacosTooltip(
                message: 'Spiegelung beenden',
                child: MacosIconButton(
                  onPressed: onClose,
                  icon: MacosIcon(CupertinoIcons.clear),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _StatusDot({required final bool isLive}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = isLive
        ? context.colors.deviceConnected
        : context.colors.deviceDisconnected;

    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: .circle,
          color: color,
          boxShadow: [
            BoxShadow(color: color.withAlpha(90), blurRadius: 6.0),
          ],
        ),
        child: const SizedBox.square(dimension: 7.0),
      ),
    );
  }
}
