import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/components/synk_ui_icon_button.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

class const SynkUiToast({
  super.key,
  required final IconData icon,
  required final String message,
  required final Color accent,
  final VoidCallback? onDismiss,
  final IconData? dismissIcon,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;
    final dismissIcon = this.dismissIcon;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 380.0),
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
          padding: const EdgeInsets.fromLTRB(
            SynkUiSpace.s12,
            SynkUiSpace.s8,
            SynkUiSpace.s6,
            SynkUiSpace.s8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: SynkUiSpace.s8,
            children: [
              Icon(icon, size: SynkUiSize.icon, color: accent),
              Flexible(
                child: Text(
                  message,
                  style: theme.typography.body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onDismiss != null && dismissIcon != null)
                SynkUiIconButton(icon: dismissIcon, onPressed: onDismiss),
            ],
          ),
        ),
      ),
    );
  }
}
