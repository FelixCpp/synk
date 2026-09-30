import 'package:bench_ui/src/bench_theme.dart';
import 'package:bench_ui/src/components/bench_interactive.dart';
import 'package:bench_ui/src/tokens/bench_metrics.dart';
import 'package:flutter/widgets.dart';

enum BenchButtonVariant { primary, secondary, danger }

class BenchButton extends StatelessWidget {
  const BenchButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = BenchButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final BenchButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = context.bench;
    final colors = theme.colors;

    return BenchInteractive(
      onPressed: onPressed,
      builder: (context, states) {
        final pressed = states.contains(WidgetState.pressed);
        final hovered = states.contains(WidgetState.hovered);

        final (background, foreground, border) = switch (variant) {
          BenchButtonVariant.primary => (
            pressed
                ? Color.lerp(colors.accent, colors.text, 0.12)!
                : hovered
                ? Color.lerp(colors.accent, colors.onAccent, 0.10)!
                : colors.accent,
            colors.onAccent,
            const Color(0x00000000),
          ),
          BenchButtonVariant.secondary => (
            pressed
                ? Color.alphaBlend(colors.pressOverlay, colors.surface)
                : hovered
                ? Color.alphaBlend(colors.hoverOverlay, colors.surface)
                : colors.surface,
            colors.text,
            colors.line,
          ),
          BenchButtonVariant.danger => (
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
            duration: BenchMotion.state,
            curve: BenchMotion.standard,
            height: BenchSize.control,
            padding: const EdgeInsets.symmetric(horizontal: BenchSpace.s12),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(BenchRadius.control),
              border: Border.all(
                color: focused ? colors.accent : border,
                width: focused ? 2.0 : BenchSize.hairline,
              ),
            ),
            child: Center(
              widthFactor: 1.0,
              child: Text(
                label,
                style: theme.type.label.copyWith(color: foreground),
              ),
            ),
          ),
        );
      },
    );
  }
}
