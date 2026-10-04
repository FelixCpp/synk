import 'dart:math' as math;

import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/components/synk_ui_interactive.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

typedef SynkUiMenuItemsBuilder = List<Widget> Function(
  BuildContext context,
  MenuController controller,
);

typedef SynkUiMenuTriggerBuilder = Widget Function(
  BuildContext context,
  MenuController controller,
);

enum SynkUiMenuAlignment {
  start,
  end,
}

class const SynkUiMenu({
  super.key,
  required final SynkUiMenuItemsBuilder itemsBuilder,
  required final SynkUiMenuTriggerBuilder triggerBuilder,
  final double width = 200.0,
  final SynkUiMenuAlignment alignment = SynkUiMenuAlignment.end,
}) extends StatefulWidget {
  @override
  State<SynkUiMenu> createState() => _SynkUiMenuState();
}

class _SynkUiMenuState extends State<SynkUiMenu> {
  final _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    return RawMenuAnchor(
      controller: _controller,
      overlayBuilder: (context, info) {
        final anchored = widget.alignment == SynkUiMenuAlignment.end
            ? info.anchorRect.right - widget.width
            : info.anchorRect.left;

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
    final colors = context.synkUi.colors;

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(SynkUiRadius.card),
          border: .all(
            color: colors.lineStrong,
            width: SynkUiSize.hairline,
          ),
          boxShadow: SynkUiElevation.overlay,
        ),
        child: Padding(
          padding: const EdgeInsets.all(SynkUiSpace.s4),
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

class const SynkUiMenuItem({
  super.key,
  required final IconData icon,
  required final String label,
  required final VoidCallback? onPressed,
  final bool destructive = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;

    return SynkUiInteractive(
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
            borderRadius: BorderRadius.circular(SynkUiRadius.control),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SynkUiSpace.s8,
              vertical: SynkUiSpace.s6,
            ),
            child: Row(
              spacing: SynkUiSpace.s8,
              children: [
                Icon(icon, size: SynkUiSize.icon, color: foreground),
                Expanded(
                  child: Text(
                    label,
                    style: theme.typography.label.copyWith(color: foreground),
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

class const SynkUiMenuDivider({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SynkUiSpace.s4),
      child: Container(
        height: SynkUiSize.hairline,
        color: context.synkUi.colors.line,
      ),
    );
  }
}
