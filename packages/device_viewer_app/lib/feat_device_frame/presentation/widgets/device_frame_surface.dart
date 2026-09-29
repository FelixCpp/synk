import 'package:device_viewer/design/build_context.dart';
import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:flutter/cupertino.dart';

class const DeviceFrameSurface({
  super.key,
  required final bool hasFocus,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: hasFocus ? 1.0 : 0.0),
      duration: DeviceViewerTheme.focusTransitionDuration,
      curve: Curves.easeOut,
      builder: (context, focus, child) => DecoratedBox(
        decoration: _frameDecoration(context, focus),
        child: child,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          DeviceViewerTheme.cornerRadius - DeviceViewerTheme.hairlineThickness,
        ),
        child: child,
      ),
    );
  }
}

BoxDecoration _frameDecoration(BuildContext context, double focus) {
  final colors = context.colors;

  return BoxDecoration(
    color: colors.card,
    borderRadius: BorderRadius.circular(DeviceViewerTheme.cornerRadius),
    border: Border.all(
      color: Color.lerp(colors.divider, colors.focusRing, focus)!,
      width: DeviceViewerTheme.hairlineThickness,
    ),
    boxShadow: [
      BoxShadow(
        color: colors.shadow,
        blurRadius: DeviceViewerTheme.cardShadow,
        offset: DeviceViewerTheme.cardShadowOffset,
      ),
      BoxShadow(
        color: Color.lerp(const Color(0x00000000), colors.focusGlow, focus)!,
        blurRadius: DeviceViewerTheme.focusRingBlur,
        spreadRadius: DeviceViewerTheme.focusRingThickness * focus,
      ),
    ],
  );
}
