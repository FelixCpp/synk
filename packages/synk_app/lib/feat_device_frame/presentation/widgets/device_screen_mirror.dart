import 'package:synk/design/build_context.dart';
import 'package:synk/design/theme/synk_colors.dart';
import 'package:synk/design/theme/synk_theme.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:flutter/cupertino.dart';

class const DeviceScreenMirror({
  super.key,
  required final NativeTextureId textureId,
  required final String modelName,
  required final bool hasFocus,
  required final Animation<double> flash,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .expand,
      children: [
        ColoredBox(
          color: SynkColors.mirrorBackground,
          child: Texture(textureId: textureId),
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: Padding(
            padding: SynkTheme.statusOverlayPadding,
            child: _StatusOverlay(hasFocus: hasFocus),
          ),
        ),
        IgnorePointer(
          child: FadeTransition(
            opacity: flash,
            child: const ColoredBox(
              color: SynkColors.screenshotFlash,
            ),
          ),
        ),
      ],
    );
  }
}

class const _StatusOverlay({required final bool hasFocus})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Row(
        mainAxisSize: .min,
        spacing: SynkTheme.horizontalComponentSpacingSmall,
        children: [
          _KeyboardTargetBadge(hasFocus: hasFocus),
        ],
      ),
    );
  }
}

class const _KeyboardTargetBadge({required final bool hasFocus})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: SynkTheme.focusTransitionDuration,
      curve: Curves.easeOut,
      opacity: hasFocus ? 1.0 : 0.0,
      child: _StatusBadge(
        child: Icon(
          CupertinoIcons.keyboard,
          size: SynkTheme.statusOverlayIconSize,
          color: context.synkUiTheme.colors.accent,
        ),
      ),
    );
  }
}

class const _StatusBadge({required final Widget child})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SynkColors.statusOverlayBackground,
        borderRadius: BorderRadius.circular(
          SynkTheme.statusOverlayRadius,
        ),
      ),
      child: Padding(
        padding: SynkTheme.statusOverlayInsets,
        child: child,
      ),
    );
  }
}
