import 'dart:math' as math;

import 'package:bench_ui/src/bench_theme.dart';
import 'package:bench_ui/src/components/bench_interactive.dart';
import 'package:bench_ui/src/tokens/bench_metrics.dart';
import 'package:flutter/widgets.dart';

typedef BenchMenuItemsBuilder =
    List<Widget> Function(BuildContext context, MenuController controller);

typedef BenchMenuTriggerBuilder =
    Widget Function(BuildContext context, MenuController controller);

enum BenchMenuAlignment { start, end }

class BenchMenu extends StatefulWidget {
  const BenchMenu({
    super.key,
    required this.itemsBuilder,
    required this.triggerBuilder,
    this.width = 200.0,
    this.alignment = BenchMenuAlignment.end,
  });

  final BenchMenuItemsBuilder itemsBuilder;
  final BenchMenuTriggerBuilder triggerBuilder;
  final double width;
  final BenchMenuAlignment alignment;

  @override
  State<BenchMenu> createState() => _BenchMenuState();
}

class _BenchMenuState extends State<BenchMenu> {
  final _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    return RawMenuAnchor(
      controller: _controller,
      overlayBuilder: (context, info) {
        final anchored = widget.alignment == BenchMenuAlignment.end
            ? info.anchorRect.right - widget.width
            : info.anchorRect.left;

        final maxLeft = math.max(
          BenchSpace.s8,
          info.overlaySize.width - widget.width - BenchSpace.s8,
        );

        return Positioned(
          left: anchored.clamp(BenchSpace.s8, maxLeft),
          top: info.anchorRect.bottom + BenchSpace.s6,
          child: TapRegion(
            groupId: info.tapRegionGroupId,
            onTapOutside: (_) => _controller.close(),
            child: _Panel(
              width: widget.width,
              children: widget.itemsBuilder(context, _controller),
            ),
          ),
        );
      },
      builder: (context, controller, child) =>
          widget.triggerBuilder(context, controller),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.width, required this.children});

  final double width;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.bench.colors;

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(BenchRadius.card),
          border: Border.all(
            color: colors.lineStrong,
            width: BenchSize.hairline,
          ),
          boxShadow: BenchElevation.overlay,
        ),
        child: Padding(
          padding: const EdgeInsets.all(BenchSpace.s4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

class BenchMenuItem extends StatelessWidget {
  const BenchMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final theme = context.bench;
    final colors = theme.colors;

    return BenchInteractive(
      onPressed: onPressed,
      builder: (context, states) {
        final highlighted =
            states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused);

        final foreground = switch (states) {
          _ when states.contains(WidgetState.disabled) => colors.textTertiary,
          _ when highlighted => colors.onAccent,
          _ when destructive => colors.error,
          _ => colors.text,
        };

        return DecoratedBox(
          decoration: BoxDecoration(
            color: highlighted ? colors.accent : const Color(0x00000000),
            borderRadius: BorderRadius.circular(BenchRadius.control),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: BenchSpace.s8,
              vertical: BenchSpace.s6,
            ),
            child: Row(
              spacing: BenchSpace.s8,
              children: [
                Icon(icon, size: BenchSize.icon, color: foreground),
                Expanded(
                  child: Text(
                    label,
                    style: theme.type.label.copyWith(color: foreground),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BenchMenuDivider extends StatelessWidget {
  const BenchMenuDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: BenchSpace.s4),
      child: Container(
        height: BenchSize.hairline,
        color: context.bench.colors.line,
      ),
    );
  }
}
