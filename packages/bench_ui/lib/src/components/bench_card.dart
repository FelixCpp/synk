import 'package:bench_ui/src/bench_theme.dart';
import 'package:bench_ui/src/tokens/bench_metrics.dart';
import 'package:flutter/widgets.dart';

class BenchCard extends StatelessWidget {
  const BenchCard({
    super.key,
    required this.child,
    this.radius = BenchRadius.card,
    this.padding = EdgeInsets.zero,
    this.elevation = BenchElevation.flat,
    this.clip = false,
    this.focused = false,
  });

  final Widget child;
  final double radius;
  final EdgeInsets padding;
  final List<BoxShadow> elevation;
  final bool clip;
  final bool focused;

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
        child: clip ? ClipRRect(borderRadius: borderRadius, child: child) : child,
      ),
    );
  }
}
