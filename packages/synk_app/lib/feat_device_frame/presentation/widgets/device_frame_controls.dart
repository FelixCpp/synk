import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';

class const DeviceFrameControls({
  super.key,
  required final VoidCallback onBackPressed,
  required final VoidCallback onHomePressed,
  required final VoidCallback onAppLibraryPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.bench.colors;

    return ColoredBox(
      color: colors.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: BenchSpace.s4),
        child: Row(
          mainAxisAlignment: .spaceEvenly,
          children: [
            BenchTooltip(
              message: 'Zurück',
              child: BenchIconButton(
                icon: CupertinoIcons.back,
                size: 38.0,
                iconSize: 22.0,
                onPressed: onBackPressed,
              ),
            ),
            BenchTooltip(
              message: 'Home',
              child: BenchIconButton(
                icon: CupertinoIcons.home,
                size: 38.0,
                iconSize: 20.0,
                onPressed: onHomePressed,
              ),
            ),
            BenchTooltip(
              message: 'Übersicht',
              child: BenchIconButton(
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
