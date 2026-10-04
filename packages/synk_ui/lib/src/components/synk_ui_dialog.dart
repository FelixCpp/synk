import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

class const SynkUiDialog({
  super.key,
  required final String title,
  required final String message,
  required final List<Widget> actions,
  final IconData? icon,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;
    final icon = this.icon;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(SynkUiRadius.card),
            border: Border.all(
              color: colors.lineStrong,
              width: SynkUiSize.hairline,
            ),
            boxShadow: SynkUiElevation.modal,
          ),
          child: Padding(
            padding: const EdgeInsets.all(SynkUiSpace.s24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: SynkUiSpace.s12,
              children: [
                if (icon != null)
                  Icon(icon, size: 28.0, color: colors.textSecondary),
                Text(title, style: theme.typography.heading),
                Text(message, style: theme.typography.secondary),
                Padding(
                  padding: const EdgeInsets.only(top: SynkUiSpace.s4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: SynkUiSpace.s8,
                    children: actions,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<T?> showSynkUiDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = false,
}) {
  final theme = SynkUiTheme.of(context);

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierDismissible ? 'Dialog' : null,
    barrierColor: theme.colors.canvas.withValues(alpha: 0.55),
    transitionDuration: SynkUiMotion.present,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: SynkUiMotion.emphasized,
      );

      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.97, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}
