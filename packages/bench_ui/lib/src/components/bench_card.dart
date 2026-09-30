import 'package:bench_ui/src/bench_theme.dart';
import 'package:bench_ui/src/tokens/bench_metrics.dart';
import 'package:flutter/widgets.dart';

class const BenchCard({
  super.key,
  required final Widget child,
  final double radius = BenchRadius.card,
  final EdgeInsets padding = EdgeInsets.zero,
  final List<BoxShadow> elevation = BenchElevation.flat,
  final bool clip = false,
  final bool focused = false,
  final Color overlayColor = const Color(0x00000000),
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.bench.colors;
    final borderRadius = BorderRadius.circular(radius);

    return AnimatedContainer(
      duration: BenchMotion.state,
      curve: BenchMotion.standard,
      decoration: BoxDecoration(
        color: colors.surface,
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
          width: BenchSize.hairline,
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
