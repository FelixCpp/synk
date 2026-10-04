import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/components/synk_ui_interactive.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

class const SynkUiIconButton({
  super.key,
  required final IconData icon,
  required final VoidCallback? onPressed,
  final double size = SynkUiSize.iconButton,
  final double iconSize = SynkUiSize.icon,
  final Color? color,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.synkUi.colors;

    return SynkUiInteractive(
      onPressed: onPressed,
      builder: (context, states) {
        final disabled = states.contains(WidgetState.disabled);

        final background = switch (states) {
          _ when disabled => const Color(0x00000000),
          _ when states.contains(WidgetState.pressed) => colors.pressOverlay,
          _ when states.contains(WidgetState.hovered) => colors.hoverOverlay,
          _ => const Color(0x00000000),
        };

        final foreground = switch (states) {
          _ when disabled => colors.textTertiary.withValues(alpha: 0.45),
          _ when states.contains(WidgetState.hovered) => color ?? colors.text,
          _ => color ?? colors.textSecondary,
        };

        return AnimatedContainer(
          duration: SynkUiMotion.state,
          curve: SynkUiMotion.standard,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(SynkUiRadius.control),
            border: Border.all(
              color: states.contains(WidgetState.focused)
                  ? colors.accent
                  : const Color(0x00000000),
              width: 2.0,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: iconSize, color: foreground),
        );
      },
    );
  }
}
