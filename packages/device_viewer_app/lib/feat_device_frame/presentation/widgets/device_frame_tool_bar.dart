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
  required final VoidCallback onCaptureScreenshot,
  required final VoidCallback onToggleMaximize,
  required final VoidCallback onClose,
  required final VoidCallback onStandby,
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
                useMousePosition: false,
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
              onCaptureScreenshot: onCaptureScreenshot,
              onToggleMaximize: onToggleMaximize,
              onClose: onClose,
              onStandby: onStandby,
            ),
          ],
        ),
      ),
    );
  }
}

class const _Actions({
  required final bool isMaximized,
  required final VoidCallback onCaptureScreenshot,
  required final VoidCallback onToggleMaximize,
  required final VoidCallback onClose,
  required final VoidCallback onStandby,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MacosIconTheme(
      data: MacosIconThemeData(
        color: context.colors.label,
        size: 18.0,
      ),
      child: Row(
        children: [
          // TODO(Felix): wire up recording the mirrored stream to a file.
          MacosTooltip(
            useMousePosition: false,
            message: 'Aufnahme starten',
            child: MacosIconButton(
              onPressed: () {},
              icon: MacosIcon(CupertinoIcons.video_camera),
            ),
          ),
          MacosTooltip(
            useMousePosition: false,
            message: 'Screenshot aufnehmen',
            child: MacosIconButton(
              onPressed: onCaptureScreenshot,
              icon: MacosIcon(CupertinoIcons.camera),
            ),
          ),
          MacosTooltip(
            useMousePosition: false,
            message: isMaximized ? 'Vollbild verlassen' : 'Gerät maximieren',
            child: MacosIconButton(
              onPressed: onToggleMaximize,
              icon: MacosIcon(
                isMaximized
                    ? CupertinoIcons.arrow_down_right_arrow_up_left
                    : CupertinoIcons.arrow_up_left_arrow_down_right,
              ),
            ),
          ),
          _OverflowButton(onStandby: onStandby),
          MacosTooltip(
            useMousePosition: false,
            message: 'Spiegelung beenden',
            child: MacosIconButton(
              onPressed: onClose,
              icon: MacosIcon(CupertinoIcons.clear),
            ),
          ),
        ],
      ),
    );
  }
}

class const _OverflowButton({required final VoidCallback onStandby})
    extends StatefulWidget {
  @override
  State<_OverflowButton> createState() => _OverflowButtonState();
}

class _OverflowButtonState extends State<_OverflowButton> {
  final _popupKey = GlobalKey<ToolbarPopupState>();

  @override
  Widget build(BuildContext context) {
    return ToolbarPopup(
      key: _popupKey,
      // ToolbarPopup anchors to the child's vertical *center*, not its
      // bottom edge - this has to clear half the button's max height
      // (MacosIconButton's default boxConstraints go up to 30px) plus an
      // actual gap, or the menu opens overlapping the button itself.
      verticalOffset: 24.0,
      horizontalOffset: 6.0,
      position: .below,
      placement: .end,
      content: (context) => _OverflowMenu(onStandby: widget.onStandby),
      child: MacosTooltip(
        useMousePosition: false,
        message: 'Mehr',
        child: MacosIconButton(
          onPressed: () => _popupKey.currentState?.openPopup(),
          icon: MacosIcon(CupertinoIcons.ellipsis_vertical),
        ),
      ),
    );
  }
}

class const _OverflowMenu({required final VoidCallback onStandby})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(
          DeviceViewerTheme.smallCornerRadius,
        ),
        border: Border.all(
          color: context.colors.divider,
          width: DeviceViewerTheme.hairlineThickness,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: DeviceViewerTheme.cardShadow,
            offset: DeviceViewerTheme.cardShadowOffset,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          DeviceViewerTheme.smallCornerRadius,
        ),
        child: _OverflowMenuItem(
          icon: CupertinoIcons.power,
          label: 'Standby',
          onTap: () {
            Navigator.of(context).pop();
            onStandby();
          },
        ),
      ),
    );
  }
}

class const _OverflowMenuItem({
  required final IconData icon,
  required final String label,
  required final VoidCallback onTap,
}) extends StatefulWidget {
  @override
  State<_OverflowMenuItem> createState() => _OverflowMenuItemState();
}

class _OverflowMenuItemState extends State<_OverflowMenuItem> {
  var _isHovered = false;
  var _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.macosTheme.brightness == .dark;
    // Same neutral scrim PushButton uses for its click effect
    // (push_button.dart's _getClickEffectBoxDecoration) - painted as a
    // foreground layer so it stacks on top of the hover tint instead of
    // replacing it with an unrelated accent color.
    final clickEffectColor = isDark
        ? const Color.fromRGBO(255, 255, 255, 0.15)
        : const Color.fromRGBO(0, 0, 0, 0.06);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapCancel: () => setState(() => _isPressed = false),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: DeviceViewerTheme.actionRevealDuration,
          color: _isHovered ? context.colors.cardHover : const Color(0x00000000),
          foregroundDecoration: BoxDecoration(
            color: _isPressed ? clickEffectColor : const Color(0x00000000),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 8.0,
          ),
          child: Row(
            mainAxisSize: .min,
            spacing: DeviceViewerTheme.horizontalComponentSpacingSmall,
            children: [
              MacosIcon(
                widget.icon,
                size: 15.0,
                color: context.colors.label,
              ),
              Text(widget.label, style: context.typo.body),
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
