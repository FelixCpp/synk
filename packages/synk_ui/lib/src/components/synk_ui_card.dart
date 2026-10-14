import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

class const SynkUiCard({
  super.key,
  required final Widget child,
  final double radius = SynkUiRadius.card,
  final EdgeInsets padding = EdgeInsets.zero,
  final List<BoxShadow> elevation = SynkUiElevation.flat,
  final bool clip = false,
  final bool focused = false,
  final Color? color,
  final Color overlayColor = const Color(0x00000000),
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.synkUi.colors;
    final borderRadius = BorderRadius.circular(radius);

    return AnimatedContainer(
      duration: SynkUiMotion.state,
      curve: SynkUiMotion.standard,
      decoration: BoxDecoration(
        color: color ?? colors.surface,
        borderRadius: borderRadius,
        boxShadow: elevation,
      ),
      foregroundDecoration: BoxDecoration(
        color: overlayColor,
        borderRadius: borderRadius,
        border: Border.all(
          color: focused
              ? colors.accent
              : elevation.isEmpty
              ? colors.line
              : colors.lineStrong,
          width: SynkUiSize.hairline,
        ),
      ),
      child: Padding(
        padding: padding,
        child: clip
            ? ClipRRect(borderRadius: borderRadius, child: child)
            : child,
      ),
    );
  }
}
