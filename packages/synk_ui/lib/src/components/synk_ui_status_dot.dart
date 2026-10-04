import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

class const SynkUiStatusDot({
  super.key,
  required final Color color,
  final bool glow = false,
  final double size = SynkUiSize.statusDot,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: SynkUiMotion.state,
      curve: SynkUiMotion.standard,
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
