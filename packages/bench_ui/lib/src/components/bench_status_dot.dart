import 'package:bench_ui/src/tokens/bench_metrics.dart';
import 'package:flutter/widgets.dart';

class const BenchStatusDot({
  super.key,
  required final Color color,
  final bool glow = false,
  final double size = BenchSize.statusDot,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: BenchMotion.state,
      curve: BenchMotion.standard,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: glow
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.55),
                  blurRadius: 6.0,
                  spreadRadius: 1.0,
                ),
              ]
            : const [],
      ),
    );
  }
}
