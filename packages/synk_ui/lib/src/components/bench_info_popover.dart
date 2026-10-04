import 'dart:math' as math;

import 'package:synk_ui/src/bench_theme.dart';
import 'package:synk_ui/src/tokens/bench_metrics.dart';
import 'package:flutter/widgets.dart';

typedef BenchInfoPopoverTriggerBuilder = Widget Function(
  BuildContext context,
  MenuController controller,
);

class const BenchInfoRow({
  required final String label,
  required final String value,
  final bool monospace = false,
});

class const BenchInfoPopover({
  super.key,
  required final String title,
  required final List<BenchInfoRow> rows,
  required final BenchInfoPopoverTriggerBuilder triggerBuilder,
  final double width = 260.0,
}) extends StatefulWidget {
  @override
  State<BenchInfoPopover> createState() => _BenchInfoPopoverState();
}

class _BenchInfoPopoverState extends State<BenchInfoPopover> {
  final _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    return RawMenuAnchor(
      controller: _controller,
      overlayBuilder: (context, info) {
        final anchored = info.anchorRect.right - widget.width;
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
              title: widget.title,
              rows: widget.rows,
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
  const _Panel({
    required this.width,
    required this.title,
    required this.rows,
  });

  final double width;
  final String title;
  final List<BenchInfoRow> rows;

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
          padding: const EdgeInsets.all(BenchSpace.s12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: context.bench.typography.title),
              const SizedBox(height: BenchSpace.s8),
              Container(height: BenchSize.hairline, color: colors.line),
              const SizedBox(height: BenchSpace.s4),
              for (final row in rows) _InfoRowTile(row: row),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRowTile extends StatelessWidget {
  const _InfoRowTile({required this.row});

  final BenchInfoRow row;

  @override
  Widget build(BuildContext context) {
    final theme = context.bench;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: BenchSpace.s4),
      child: Row(
        children: [
          Expanded(
            child: Text(row.label, style: theme.typography.secondary),
          ),
          const SizedBox(width: BenchSpace.s12),
          Text(
            row.value,
            style: row.monospace
                ? theme.typography.mono
                : theme.typography.label,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
