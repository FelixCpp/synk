import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

class const SynkUiTag({
  super.key,
  required final String label,
  required final Color color,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.soft(color),
        borderRadius: BorderRadius.circular(SynkUiRadius.tag),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SynkUiSpace.s6,
          vertical: SynkUiSpace.s2,
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
