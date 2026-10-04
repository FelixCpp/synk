import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

class const SynkUiShell({
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
    final theme = context.synkUi;
    final colors = theme.colors;

    return ColoredBox(
      color: colors.panel,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedContainer(
            duration: SynkUiMotion.move,
            curve: SynkUiMotion.emphasized,
            width: showSidebar ? SynkUiSize.sidebarWidth : 0.0,
            child: ClipRect(
              child: OverflowBox(
                alignment: Alignment.centerLeft,
                minWidth: SynkUiSize.sidebarWidth,
                maxWidth: SynkUiSize.sidebarWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: SynkUiSize.titleStrip),
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
                  height: SynkUiSize.titleStrip,
                  child: AnimatedPadding(
                    duration: SynkUiMotion.move,
                    curve: SynkUiMotion.emphasized,
                    padding: EdgeInsets.only(
                      left: showSidebar
                          ? SynkUiSpace.s12
                          : SynkUiSize.trafficGutter +
                                (leading == null ? SynkUiSpace.s12 : 0.0),
                      right: SynkUiSpace.s8,
                    ),
                    child: Row(
                      children: [
                        if (leading != null) ...[
                          leading!,
                          const SizedBox(width: SynkUiSpace.s8),
                        ],
                        Expanded(
                          child: Text(
                            title,
                            style: theme.typography.secondary.copyWith(
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
    final colors = context.synkUi.colors;

    const outer = BorderRadius.only(
      topLeft: .circular(SynkUiRadius.card),
    );
    const inner = BorderRadius.only(
      topLeft: .circular(SynkUiRadius.card - SynkUiSize.hairline),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.line,
        borderRadius: outer,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: SynkUiSize.hairline,
          left: SynkUiSize.hairline,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.canvas,
            borderRadius: inner,
          ),
          child: ClipRRect(
            borderRadius: inner,
            child: child,
          ),
        ),
      ),
    );
  }
}
