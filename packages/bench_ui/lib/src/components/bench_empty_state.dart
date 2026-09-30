import 'package:bench_ui/src/bench_theme.dart';
import 'package:bench_ui/src/tokens/bench_metrics.dart';
import 'package:flutter/widgets.dart';

class BenchEmptyState extends StatelessWidget {
  const BenchEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.iconSize = 40.0,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = context.bench;
    final action = this.action;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(BenchSpace.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: BenchSpace.s12,
          children: [
            Icon(icon, size: iconSize, color: theme.colors.textTertiary),
            Text(title, style: theme.type.title, textAlign: TextAlign.center),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320.0),
              child: Text(
                message,
                style: theme.type.secondary,
                textAlign: TextAlign.center,
              ),
            ),
            if (action != null)
              Padding(
                padding: const EdgeInsets.only(top: BenchSpace.s4),
                child: action,
              ),
          ],
        ),
      ),
    );
  }
}
