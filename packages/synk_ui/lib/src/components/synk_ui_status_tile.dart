import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

class const SynkUiStatusTile({
  super.key,
  required final IconData icon,
  required final Color color,
  final double size = SynkUiSize.statusTile,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.synkUi.colors;

    return AnimatedContainer(
      duration: SynkUiMotion.state,
      curve: SynkUiMotion.standard,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.soft(color),
        borderRadius: BorderRadius.circular(SynkUiRadius.row),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: size * 0.5, color: color),
    );
  }
}
