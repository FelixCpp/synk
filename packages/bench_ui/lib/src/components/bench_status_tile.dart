import 'package:bench_ui/src/bench_theme.dart';
import 'package:bench_ui/src/tokens/bench_metrics.dart';
import 'package:flutter/widgets.dart';

class BenchStatusTile extends StatelessWidget {
  const BenchStatusTile({
    super.key,
    required this.icon,
    required this.color,
    this.size = BenchSize.statusTile,
  });

  final IconData icon;
  final Color color;
  final double size;

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
