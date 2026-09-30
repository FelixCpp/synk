import 'package:bench_ui/src/bench_theme.dart';
import 'package:bench_ui/src/tokens/bench_metrics.dart';
import 'package:flutter/widgets.dart';

class BenchListRow extends StatefulWidget {
  const BenchListRow({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.revealTrailingOnHover = true,
    this.selected = false,
    this.onTap,
    this.onSecondaryTap,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final bool revealTrailingOnHover;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onSecondaryTap;

  @override
  State<BenchListRow> createState() => _BenchListRowState();
}

class _BenchListRowState extends State<BenchListRow> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.bench;
    final colors = theme.colors;
    final trailing = widget.trailing;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onSecondaryTap: widget.onSecondaryTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: BenchMotion.state,
          curve: BenchMotion.standard,
          padding: const EdgeInsets.symmetric(
            horizontal: BenchSpace.s8,
            vertical: BenchSpace.s6,
          ),
          decoration: BoxDecoration(
            color: widget.selected
                ? colors.soft(colors.accent)
                : _hovered
                ? colors.hoverOverlay
                : const Color(0x00000000),
            borderRadius: BorderRadius.circular(BenchRadius.row),
          ),
          child: Row(
            children: [
              widget.leading,
              const SizedBox(width: BenchSpace.s8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: theme.type.label,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      widget.subtitle,
                      style: theme.type.mono,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: BenchSpace.s6),
                AnimatedOpacity(
                  duration: BenchMotion.reveal,
                  curve: BenchMotion.standard,
                  opacity: !widget.revealTrailingOnHover || _hovered ? 1.0 : 0.0,
                  child: trailing,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
