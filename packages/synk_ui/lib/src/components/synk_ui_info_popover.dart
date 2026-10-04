import 'dart:math' as math;

import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

typedef SynkUiInfoPopoverTriggerBuilder = Widget Function(
  BuildContext context,
  MenuController controller,
);

class const SynkUiInfoRow({
  required final String label,
  required final String value,
  final bool monospace = false,
});

class const SynkUiInfoPopover({
  super.key,
  required final String title,
  required final List<SynkUiInfoRow> rows,
  required final SynkUiInfoPopoverTriggerBuilder triggerBuilder,
  final double width = 260.0,
}) extends StatefulWidget {
  @override
  State<SynkUiInfoPopover> createState() => _SynkUiInfoPopoverState();
}

class _SynkUiInfoPopoverState extends State<SynkUiInfoPopover> {
  final _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    return RawMenuAnchor(
      controller: _controller,
      overlayBuilder: (context, info) {
        final anchored = info.anchorRect.right - widget.width;
        final maxLeft = math.max(
          SynkUiSpace.s8,
          info.overlaySize.width - widget.width - SynkUiSpace.s8,
        );

        return Positioned(
          left: anchored.clamp(SynkUiSpace.s8, maxLeft),
          top: info.anchorRect.bottom + SynkUiSpace.s6,
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
  final List<SynkUiInfoRow> rows;

  @override
  Widget build(BuildContext context) {
    final colors = context.synkUi.colors;

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(SynkUiRadius.card),
          border: Border.all(
            color: colors.lineStrong,
            width: SynkUiSize.hairline,
          ),
          boxShadow: SynkUiElevation.overlay,
        ),
        child: Padding(
          padding: const EdgeInsets.all(SynkUiSpace.s12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: context.synkUi.typography.title),
              const SizedBox(height: SynkUiSpace.s8),
              Container(height: SynkUiSize.hairline, color: colors.line),
              const SizedBox(height: SynkUiSpace.s4),
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

  final SynkUiInfoRow row;

  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SynkUiSpace.s4),
      child: Row(
        children: [
          Expanded(
            child: Text(row.label, style: theme.typography.secondary),
          ),
          const SizedBox(width: SynkUiSpace.s12),
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
