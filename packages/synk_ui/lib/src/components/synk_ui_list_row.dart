import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

class const SynkUiListRow({
  super.key,
  required final Widget leading,
  required final String title,
  required final String subtitle,
  final Widget? trailing,
  final bool revealTrailingOnHover = true,
  final bool selected = false,
  final VoidCallback? onTap,
  final VoidCallback? onSecondaryTap,
}) extends StatefulWidget {
  @override
  State<SynkUiListRow> createState() => _SynkUiListRowState();
}

class _SynkUiListRowState extends State<SynkUiListRow> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
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
          duration: SynkUiMotion.state,
          curve: SynkUiMotion.standard,
          padding: const EdgeInsets.symmetric(
            horizontal: SynkUiSpace.s8,
            vertical: SynkUiSpace.s6,
          ),
          decoration: BoxDecoration(
            color: widget.selected
                ? colors.soft(colors.accent)
                : _hovered
                ? colors.hoverOverlay
                : const Color(0x00000000),
            borderRadius: BorderRadius.circular(SynkUiRadius.row),
          ),
          child: Row(
            children: [
              widget.leading,
              const SizedBox(width: SynkUiSpace.s8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: theme.typography.label,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      widget.subtitle,
                      style: theme.typography.mono,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: SynkUiSpace.s6),
                AnimatedOpacity(
                  duration: SynkUiMotion.reveal,
                  curve: SynkUiMotion.standard,
                  opacity: !widget.revealTrailingOnHover || _hovered
                      ? 1.0
                      : 0.0,
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
