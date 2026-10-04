import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

class const SynkUiTooltip({
  super.key,
  required final String message,
  required final Widget child,
  final Duration hoverDelay = const .new(milliseconds: 500),
  final double verticalOffset = SynkUiSpace.s8,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawTooltip(
      semanticsTooltip: message,
      hoverDelay: hoverDelay,
      triggerMode: .manual,
      enableTapToDismiss: true,
      ignorePointer: true,
      positionDelegate: (context) => positionDependentBox(
        size: context.overlaySize,
        childSize: context.tooltipSize,
        target: context.target,
        preferBelow: context.preferBelow,
        verticalOffset: verticalOffset,
      ),
      tooltipBuilder: (context, animation) => IgnorePointer(
        child: FadeTransition(
          opacity: animation,
          child: _Bubble(message: message),
        ),
      ),
      child: child,
    );
  }
}

class const _Bubble({
  required final String message,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: BorderRadius.circular(SynkUiRadius.control),
        border: Border.all(
          color: theme.colors.lineStrong,
          width: SynkUiSize.hairline,
        ),
        boxShadow: SynkUiElevation.overlay,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SynkUiSpace.s8,
          vertical: SynkUiSpace.s4,
        ),
        child: Text(
          message,
          style: theme.typography.secondary.copyWith(color: theme.colors.text),
        ),
      ),
    );
  }
}
