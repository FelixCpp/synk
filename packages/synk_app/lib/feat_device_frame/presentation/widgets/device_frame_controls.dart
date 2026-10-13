import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';

class const DeviceFrameControls({
  super.key,
  final VoidCallback? onBackPressed,
  final VoidCallback? onHomePressed,
  final VoidCallback? onAppLibraryPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.synkUi.colors;

    return ColoredBox(
      color: colors.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: SynkUiSpace.s4),
        child: Row(
          mainAxisAlignment: .spaceEvenly,
          children: [
            if (onBackPressed != null)
              SynkUiTooltip(
                message: 'Zurück',
                child: SynkUiIconButton(
                  icon: CupertinoIcons.back,
                  size: 38.0,
                  iconSize: 22.0,
                  onPressed: onBackPressed,
                ),
              ),
            if (onHomePressed != null)
              SynkUiTooltip(
                message: 'Home',
                child: SynkUiIconButton(
                  icon: CupertinoIcons.home,
                  size: 38.0,
                  iconSize: 20.0,
                  onPressed: onHomePressed,
                ),
              ),
            if (onAppLibraryPressed != null)
              SynkUiTooltip(
                message: 'Übersicht',
                child: SynkUiIconButton(
                  icon: CupertinoIcons.line_horizontal_3,
                  size: 38.0,
                  iconSize: 22.0,
                  onPressed: onAppLibraryPressed,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
