import 'package:synk/feat_device_frame/presentation/device_frame_metrics.dart';
import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';

/// A single white frame, flashed when a screenshot is taken.
const _screenshotFlash = Color(0xFFFFFFFF);

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
          color: SynkUiScrim.below,
          child: Texture(textureId: textureId),
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: Padding(
            padding: DeviceFrameMetrics.overlayPadding,
            child: _KeyboardTargetBadge(hasFocus: hasFocus),
          ),
        ),
        IgnorePointer(
          child: FadeTransition(
            opacity: flash,
            child: const ColoredBox(color: _screenshotFlash),
          ),
        ),
      ],
    );
  }
}

class const _KeyboardTargetBadge({required final bool hasFocus})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: SynkUiMotion.state,
      curve: Curves.easeOut,
      opacity: hasFocus ? 1.0 : 0.0,
      child: _StatusBadge(
        child: Icon(
          CupertinoIcons.keyboard,
          size: DeviceFrameMetrics.overlayIconSize,
          color: context.synkUi.colors.accent,
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
        color: SynkUiScrim.surface,
        borderRadius: BorderRadius.circular(SynkUiScrim.radius),
      ),
      child: Padding(
        padding: SynkUiScrim.insets,
        child: child,
      ),
    );
  }
}
