import 'package:synk_ui/src/synk_ui_theme.dart';
import 'package:synk_ui/src/components/synk_ui_icon_button.dart';
import 'package:synk_ui/src/components/synk_ui_tag.dart';
import 'package:synk_ui/src/tokens/synk_ui_metrics.dart';
import 'package:flutter/widgets.dart';

class const SynkUiToast({
  super.key,
  required final IconData icon,
  required final String message,
  required final Color accent,
  final int count = 1,
  final double? progress,
  final VoidCallback? onDismiss,
  final IconData? dismissIcon,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;
    final dismissIcon = this.dismissIcon;
    final borderRadius = BorderRadius.circular(SynkUiRadius.card);

    return SizedBox(
      width: SynkUiSize.toastWidth,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: borderRadius,
          border: Border.all(
            color: colors.lineStrong,
            width: SynkUiSize.hairline,
          ),
          boxShadow: SynkUiElevation.overlayFor(theme.brightness),
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  SynkUiSpace.s12 + SynkUiSize.toastRail,
                  SynkUiSpace.s8,
                  SynkUiSpace.s6,
                  SynkUiSpace.s8,
                ),
                child: Row(
                  spacing: SynkUiSpace.s8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: SynkUiSpace.s2),
                      child: Icon(icon, size: SynkUiSize.icon, color: accent),
                    ),
                    Expanded(
                      child: Text(message, style: theme.typography.body),
                    ),
                    if (count > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: SynkUiSpace.s2),
                        child: SynkUiTag(label: '×$count', color: accent),
                      ),
                    if (onDismiss != null && dismissIcon != null)
                      SynkUiIconButton(
                        icon: dismissIcon,
                        onPressed: onDismiss,
                      ),
                  ],
                ),
              ),
              Positioned(
                left: 0.0,
                top: 0.0,
                bottom: 0.0,
                child: SizedBox(
                  width: SynkUiSize.toastRail,
                  child: ColoredBox(color: accent),
                ),
              ),
              if (progress != null)
                Positioned(
                  left: SynkUiSize.toastRail,
                  right: 0.0,
                  bottom: 0.0,
                  height: SynkUiSize.toastProgress,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress!.clamp(0.0, 1.0),
                    child: ColoredBox(color: accent.withValues(alpha: 0.7)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
