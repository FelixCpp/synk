import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/components/synk_ui_interactive.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

enum SynkUiButtonVariant {
  primary,
  secondary,
  danger,
}

class const SynkUiButton({
  super.key,
  required final String label,
  final VoidCallback? onPressed,
  final SynkUiButtonVariant variant = .primary,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;

    return SynkUiInteractive(
      onPressed: onPressed,
      builder: (context, states) {
        final pressed = states.contains(WidgetState.pressed);
        final hovered = states.contains(WidgetState.hovered);

        final (background, foreground, border) = switch (variant) {
          SynkUiButtonVariant.primary => (
            pressed
                ? Color.lerp(colors.accent, colors.text, 0.12)!
                : hovered
                ? Color.lerp(colors.accent, colors.onAccent, 0.10)!
                : colors.accent,
            colors.onAccent,
            const Color(0x00000000),
          ),
          SynkUiButtonVariant.secondary => (
            colors.surfaceFor(states),
            colors.text,
            colors.line,
          ),
          SynkUiButtonVariant.danger => (
            pressed || hovered
                ? colors.soft(colors.error)
                : const Color(0x00000000),
            colors.error,
            colors.line,
          ),
        };

        final focused = states.contains(WidgetState.focused);

        return Opacity(
          opacity: states.contains(WidgetState.disabled) ? 0.45 : 1.0,
          child: AnimatedContainer(
            duration: SynkUiMotion.state,
            curve: SynkUiMotion.standard,
            height: SynkUiSize.control,
            padding: const EdgeInsets.symmetric(horizontal: SynkUiSpace.s12),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(SynkUiRadius.control),
              border: Border.all(
                color: focused ? colors.accent : border,
                width: focused ? 2.0 : SynkUiSize.hairline,
              ),
            ),
            child: Center(
              widthFactor: 1.0,
              child: Text(
                label,
                style: theme.typography.label.copyWith(color: foreground),
              ),
            ),
          ),
        );
      },
    );
  }
}
