import 'package:bench_ui/src/bench_theme.dart';
import 'package:bench_ui/src/tokens/bench_metrics.dart';
import 'package:flutter/widgets.dart';

class const BenchTooltip({
  super.key,
  required final String message,
  required final Widget child,
  final Duration hoverDelay = const .new(milliseconds: 500),
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawTooltip(
      semanticsTooltip: message,
      hoverDelay: hoverDelay,
      triggerMode: TooltipTriggerMode.manual,
      enableTapToDismiss: false,
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
    final theme = context.bench;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: BorderRadius.circular(BenchRadius.control),
        border: Border.all(
          color: theme.colors.lineStrong,
          width: BenchSize.hairline,
        ),
        boxShadow: BenchElevation.overlay,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: BenchSpace.s8,
          vertical: BenchSpace.s4,
        ),
        child: Text(
          message,
          style: theme.type.secondary.copyWith(color: theme.colors.text),
        ),
      ),
    );
  }
}
