import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

class const SynkUiTextField({
  super.key,
  required final TextEditingController controller,
  final String? placeholder,
  final FocusNode? focusNode,
  final bool autofocus = false,
  final bool obscureText = false,
  final TextInputType keyboardType = TextInputType.text,
  final ValueChanged<String>? onSubmitted,
}) extends StatefulWidget {
  @override
  State<SynkUiTextField> createState() => _SynkUiTextFieldState();
}

class _SynkUiTextFieldState extends State<SynkUiTextField> {
  FocusNode? _ownedFocusNode;

  FocusNode get _focusNode => widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  @override
  void dispose() {
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;

    return ListenableBuilder(
      listenable: Listenable.merge([widget.controller, _focusNode]),
      builder: (context, _) {
        final focused = _focusNode.hasFocus;
        final showPlaceholder =
            widget.controller.text.isEmpty && widget.placeholder != null;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _focusNode.requestFocus(),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.inset,
              borderRadius: BorderRadius.circular(SynkUiRadius.control),
              border: Border.all(
                color: focused ? colors.accent : colors.line,
                width: focused ? 2.0 : SynkUiSize.hairline,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SynkUiSpace.s12,
                vertical: SynkUiSpace.s8,
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  if (showPlaceholder)
                    Text(
                      widget.placeholder!,
                      style: theme.typography.body.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  EditableText(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    autofocus: widget.autofocus,
                    style: theme.typography.body.copyWith(color: colors.text),
                    cursorColor: colors.accent,
                    backgroundCursorColor: colors.textTertiary,
                    selectionColor: colors.soft(colors.accent),
                    keyboardType: widget.keyboardType,
                    obscureText: widget.obscureText,
                    maxLines: 1,
                    onSubmitted: widget.onSubmitted,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
