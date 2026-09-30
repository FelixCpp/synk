import 'package:bench_ui/src/bench_theme.dart';
import 'package:bench_ui/src/components/bench_icon_button.dart';
import 'package:bench_ui/src/tokens/bench_metrics.dart';
import 'package:flutter/widgets.dart';

class const BenchToast({
  super.key,
  required final IconData icon,
  required final String message,
  required final Color accent,
  final VoidCallback? onDismiss,
  final IconData? dismissIcon,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.bench;
    final colors = theme.colors;
    final dismissIcon = this.dismissIcon;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(BenchRadius.card),
          border: Border.all(
            color: colors.lineStrong,
            width: BenchSize.hairline,
          ),
          boxShadow: BenchElevation.overlay,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            BenchSpace.s12,
            BenchSpace.s8,
            BenchSpace.s6,
            BenchSpace.s8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: BenchSpace.s8,
            children: [
              Icon(icon, size: BenchSize.icon, color: accent),
              Flexible(
                child: Text(
                  message,
                  style: theme.type.body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onDismiss != null && dismissIcon != null)
                BenchIconButton(icon: dismissIcon, onPressed: onDismiss),
            ],
          ),
        ),
      ),
    );
  }
}
