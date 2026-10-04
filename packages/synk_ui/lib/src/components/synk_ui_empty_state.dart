import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

class const SynkUiEmptyState({
  super.key,
  required final IconData icon,
  required final String title,
  required final String message,
  final Widget? action,
  final double iconSize = 40.0,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final action = this.action;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SynkUiSpace.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: SynkUiSpace.s12,
          children: [
            Icon(icon, size: iconSize, color: theme.colors.textTertiary),
            Text(
              title,
              style: theme.typography.title,
              textAlign: TextAlign.center,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320.0),
              child: Text(
                message,
                style: theme.typography.secondary,
                textAlign: TextAlign.center,
              ),
            ),
            if (action != null)
              Padding(
                padding: const EdgeInsets.only(top: SynkUiSpace.s4),
                child: action,
              ),
          ],
        ),
      ),
    );
  }
}
