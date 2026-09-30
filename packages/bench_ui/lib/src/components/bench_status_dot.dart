import 'package:bench_ui/src/tokens/bench_metrics.dart';
import 'package:flutter/widgets.dart';

class BenchStatusDot extends StatelessWidget {
  const BenchStatusDot({
    super.key,
    required this.color,
    this.glow = false,
    this.size = BenchSize.statusDot,
  });

  final Color color;
  final bool glow;
  final double size;

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
