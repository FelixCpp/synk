import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';

class const NotificationOverflowRow({
  super.key,
  required final int hiddenCount,
  required final VoidCallback onDismissAll,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;

    return Padding(
      padding: const EdgeInsets.only(bottom: SynkUiSpace.s8),
      child: SizedBox(
        width: SynkUiSize.toastWidth,
        child: SynkUiCard(
          color: theme.colors.panel,
          elevation: SynkUiElevation.overlayFor(theme.brightness),
          padding: const EdgeInsets.fromLTRB(
            SynkUiSpace.s12,
            SynkUiSpace.s4,
            SynkUiSpace.s6,
            SynkUiSpace.s4,
          ),
          child: Row(
            spacing: SynkUiSpace.s8,
            children: [
              Expanded(
                child: Text(
                  '+$hiddenCount weitere',
                  style: theme.typography.secondary,
                ),
              ),
              SynkUiTooltip(
                message: 'Alle Meldungen schließen',
                child: SynkUiIconButton(
                  icon: CupertinoIcons.clear,
                  onPressed: onDismissAll,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
