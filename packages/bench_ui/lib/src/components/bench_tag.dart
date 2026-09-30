import 'package:bench_ui/src/bench_theme.dart';
import 'package:bench_ui/src/tokens/bench_metrics.dart';
import 'package:flutter/widgets.dart';

class const BenchTag({
  super.key,
  required final String label,
  required final Color color,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.bench;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.soft(color),
        borderRadius: BorderRadius.circular(BenchRadius.tag),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: BenchSpace.s6,
          vertical: BenchSpace.s2,
        ),
        child: Text(
          label.toUpperCase(),
          style: theme.typography.microLabel.copyWith(
            color: color,
            fontSize: 10.0,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }
}
