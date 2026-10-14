import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/components/synk_ui_interactive.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

class const SynkUiToggle({
  super.key,
  required final bool value,
  required final ValueChanged<bool>? onChanged,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.synkUi.colors;
    final onChanged = this.onChanged;
    final borderRadius = BorderRadius.circular(SynkUiSize.toggleHeight / 2);

    return SynkUiInteractive(
      onPressed: onChanged == null ? null : () => onChanged(!value),
      builder: (context, states) {
        final track = value ? colors.accent : colors.lineStrong;

        return Opacity(
          opacity: states.contains(WidgetState.disabled) ? 0.45 : 1.0,
          child: AnimatedContainer(
            duration: SynkUiMotion.state,
            curve: SynkUiMotion.standard,
            width: SynkUiSize.toggleWidth,
            height: SynkUiSize.toggleHeight,
            padding: const EdgeInsets.all(SynkUiSpace.s2),
            decoration: BoxDecoration(
              color: Color.alphaBlend(colors.overlayFor(states), track),
              borderRadius: borderRadius,
            ),
            // A layout-neutral ring, so focus never squeezes the knob.
            foregroundDecoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(
                color: states.contains(WidgetState.focused)
                    ? colors.accent
                    : const Color(0x00000000),
                width: 2.0,
              ),
            ),
            child: AnimatedAlign(
              duration: SynkUiMotion.state,
              curve: SynkUiMotion.standard,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFFFFF),
                ),
                child: SizedBox.square(dimension: SynkUiSize.toggleKnob),
              ),
            ),
          ),
        );
      },
    );
  }
}
