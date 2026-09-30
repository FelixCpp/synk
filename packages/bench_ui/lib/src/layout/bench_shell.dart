import 'package:bench_ui/src/bench_theme.dart';
import 'package:bench_ui/src/tokens/bench_metrics.dart';
import 'package:flutter/widgets.dart';

class const BenchShell({
  super.key,
  required final String title,
  required final Widget sidebar,
  required final Widget child,
  final List<Widget> actions = const [],
  final Widget? leading,
  final bool showSidebar = true,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.bench;
    final colors = theme.colors;

    return ColoredBox(
      color: colors.panel,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedContainer(
            duration: BenchMotion.move,
            curve: BenchMotion.emphasized,
            width: showSidebar ? BenchSize.sidebarWidth : 0.0,
            child: ClipRect(
              child: OverflowBox(
                alignment: Alignment.centerLeft,
                minWidth: BenchSize.sidebarWidth,
                maxWidth: BenchSize.sidebarWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: BenchSize.titleStrip),
                    Expanded(child: sidebar),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: BenchSize.titleStrip,
                  child: AnimatedPadding(
                    duration: BenchMotion.move,
                    curve: BenchMotion.emphasized,
                    padding: EdgeInsets.only(
                      left: showSidebar
                          ? BenchSpace.s12
                          : BenchSize.trafficGutter +
                                (leading == null ? BenchSpace.s12 : 0.0),
                      right: BenchSpace.s8,
                    ),
                    child: Row(
                      children: [
                        if (leading != null) ...[
                          leading!,
                          const SizedBox(width: BenchSpace.s8),
                        ],
                        Expanded(
                          child: Text(
                            title,
                            style: theme.type.secondary.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ...actions,
                      ],
                    ),
                  ),
                ),
                Expanded(child: _Seam(child: child)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Seam extends StatelessWidget {
  const _Seam({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.bench.colors;

    const outer = BorderRadius.only(
      topLeft: Radius.circular(BenchRadius.card),
    );
    const inner = BorderRadius.only(
      topLeft: Radius.circular(BenchRadius.card - BenchSize.hairline),
    );

    return DecoratedBox(
      decoration: BoxDecoration(color: colors.line, borderRadius: outer),
      child: Padding(
        padding: const EdgeInsets.only(
          top: BenchSize.hairline,
          left: BenchSize.hairline,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.canvas,
            borderRadius: inner,
          ),
          child: ClipRRect(borderRadius: inner, child: child),
        ),
      ),
    );
  }
}
