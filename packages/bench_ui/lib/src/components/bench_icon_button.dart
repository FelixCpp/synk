import 'package:bench_ui/src/bench_theme.dart';
import 'package:bench_ui/src/components/bench_interactive.dart';
import 'package:bench_ui/src/tokens/bench_metrics.dart';
import 'package:flutter/widgets.dart';

class BenchIconButton extends StatelessWidget {
  const BenchIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = BenchSize.iconButton,
    this.iconSize = BenchSize.icon,
    this.color,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.bench.colors;

    return BenchInteractive(
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
          _ when states.contains(WidgetState.hovered) =>
            color ?? colors.text,
          _ => color ?? colors.textSecondary,
        };

        return AnimatedContainer(
          duration: BenchMotion.state,
          curve: BenchMotion.standard,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(BenchRadius.control),
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
