import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/components/synk_ui_interactive.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

@immutable
class const SynkUiSegment<T>({
  required final T value,
  required final String label,
});

class const SynkUiSegmentedControl<T>({
  super.key,
  required final List<SynkUiSegment<T>> segments,
  required final T value,
  required final ValueChanged<T>? onChanged,

  final bool dense = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;
    final onChanged = this.onChanged;

    final selectedColor = theme.brightness == Brightness.dark
        ? colors.lineStrong
        : colors.surface;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.inset,
        borderRadius: BorderRadius.circular(SynkUiRadius.segment),
      ),
      child: Padding(
        padding: const EdgeInsets.all(SynkUiSpace.s2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: SynkUiSpace.s2,
          children: [
            for (final segment in segments)
              _Segment(
                label: segment.label,
                selected: segment.value == value,
                selectedColor: selectedColor,
                dense: dense,
                onPressed: onChanged == null
                    ? null
                    : () => onChanged(segment.value),
              ),
          ],
        ),
      ),
    );
  }
}

class const _Segment({
  required final String label,
  required final bool selected,
  required final Color selectedColor,
  required final bool dense,
  required final VoidCallback? onPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;
    final borderRadius = BorderRadius.circular(
      SynkUiRadius.segment - SynkUiSpace.s2,
    );

    return SynkUiInteractive(
      onPressed: onPressed,
      builder: (context, states) {
        return AnimatedContainer(
          duration: SynkUiMotion.state,
          curve: SynkUiMotion.standard,
          height: dense ? SynkUiSize.segmentDense : SynkUiSize.segment,
          padding: EdgeInsets.symmetric(
            horizontal: dense ? 10.0 : SynkUiSpace.s12,
          ),
          decoration: BoxDecoration(
            color: selected ? selectedColor : colors.overlayFor(states),
            borderRadius: borderRadius,
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x40000000),
                      blurRadius: 2.0,
                      offset: Offset(0, 1),
                    ),
                  ]
                : const [],
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(
              color: states.contains(WidgetState.focused)
                  ? colors.accent
                  : const Color(0x00000000),
              width: SynkUiSize.hairline,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: theme.typography.secondary.copyWith(
              fontWeight: FontWeight.w500,
              color: selected ? colors.text : colors.textSecondary,
            ),
          ),
        );
      },
    );
  }
}
