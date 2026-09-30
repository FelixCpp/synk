import 'package:flutter/widgets.dart';

typedef BenchStateBuilder = Widget Function(
  BuildContext context,
  Set<WidgetState> states,
);

class const BenchInteractive({
  super.key,
  required final BenchStateBuilder builder,
  final VoidCallback? onPressed,
  final MouseCursor cursor = SystemMouseCursors.basic,
  final bool autofocus = false,
}) extends StatefulWidget {
  @override
  State<BenchInteractive> createState() => _BenchInteractiveState();
}

class _BenchInteractiveState extends State<BenchInteractive> {
  late final WidgetStatesController _states = WidgetStatesController(
    widget.onPressed == null ? {WidgetState.disabled} : null,
  );

  @override
  void didUpdateWidget(covariant BenchInteractive oldWidget) {
    super.didUpdateWidget(oldWidget);
    _states.update(WidgetState.disabled, widget.onPressed == null);
  }

  @override
  void dispose() {
    _states.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;

    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) {
        if (enabled) _states.update(WidgetState.hovered, true);
      },
      onExit: (_) {
        _states.update(WidgetState.hovered, false);
        _states.update(WidgetState.pressed, false);
      },
      child: FocusableActionDetector(
        enabled: enabled,
        autofocus: widget.autofocus,
        onShowFocusHighlight: (value) =>
            _states.update(WidgetState.focused, value),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) => widget.onPressed?.call(),
          ),
        },
        child: GestureDetector(
          onTapDown: (_) => _states.update(WidgetState.pressed, true),
          onTapUp: (_) => _states.update(WidgetState.pressed, false),
          onTapCancel: () => _states.update(WidgetState.pressed, false),
          onTap: widget.onPressed,
          child: ValueListenableBuilder(
            valueListenable: _states,
            builder: (context, states, _) => widget.builder(context, states),
          ),
        ),
      ),
    );
  }
}
