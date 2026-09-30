import 'package:bench_ui/src/bench_theme.dart';
import 'package:bench_ui/src/tokens/bench_metrics.dart';
import 'package:flutter/widgets.dart';

class const BenchStatusTile({
  super.key,
  required final IconData icon,
  required final Color color,
  final double size = BenchSize.statusTile,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.bench.colors;

    return AnimatedContainer(
      duration: BenchMotion.state,
      curve: BenchMotion.standard,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.soft(color),
        borderRadius: BorderRadius.circular(BenchRadius.row),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: size * 0.5, color: color),
    );
  }
}
