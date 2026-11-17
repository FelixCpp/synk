import 'package:synk_ui/src/components/synk_ui_menu.dart';
import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

final _handlelessControls = _HandlelessSelectionControls();

class _HandlelessSelectionControls extends EmptyTextSelectionControls
    with TextSelectionHandleControls {}

class const SynkUiSelectableText(
  final String text, {
  super.key,
  required final IconData copyIcon,
  final String copyLabel = 'Kopieren',
  final TextStyle? style,
}) extends StatefulWidget {
  @override
  State<SynkUiSelectableText> createState() => _SynkUiSelectableTextState();
}

class _SynkUiSelectableTextState extends State<SynkUiSelectableText> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;

    return SelectableRegion(
      focusNode: _focusNode,
      selectionControls: _handlelessControls,
      contextMenuBuilder: (context, state) {
        final copy = state.contextMenuButtonItems
            .where((item) => item.type == ContextMenuButtonType.copy)
            .firstOrNull;
        if (copy == null) {
          return const SizedBox.shrink();
        }

        return SynkUiTheme(
          data: theme,
          child: _CopyMenu(
            anchor: state.contextMenuAnchors.primaryAnchor,
            icon: widget.copyIcon,
            label: widget.copyLabel,
            onCopy: copy.onPressed,
          ),
        );
      },
      child: Text(widget.text, style: widget.style),
    );
  }
}

class const _CopyMenu({
  required final Offset anchor,
  required final IconData icon,
  required final String label,
  required final VoidCallback? onCopy,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.synkUi.colors;

    return CustomSingleChildLayout(
      delegate: DesktopTextSelectionToolbarLayoutDelegate(anchor: anchor),
      child: IntrinsicWidth(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(SynkUiRadius.card),
            border: .all(color: colors.lineStrong, width: SynkUiSize.hairline),
            boxShadow: SynkUiElevation.overlay,
          ),
          child: Padding(
            padding: const EdgeInsets.all(SynkUiSpace.s4),
            child: SynkUiMenuItem(icon: icon, label: label, onPressed: onCopy),
          ),
        ),
      ),
    );
  }
}
