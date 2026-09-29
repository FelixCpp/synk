import 'package:device_viewer/design/build_context.dart';
import 'package:device_viewer/design/theme/device_viewer_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class const DeviceFrameControls({
  super.key,
  required final VoidCallback onBackPressed,
  required final VoidCallback onHomePressed,
  required final VoidCallback onAppLibraryPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.card,
      ),
      clipBehavior: .antiAlias,
      child: Row(
        mainAxisAlignment: .spaceEvenly,
        spacing: DeviceViewerTheme.horizontalComponentSpacingMedium,
        children: [
          MacosTooltip(
            useMousePosition: false,
            message: 'Zurück',
            child: MacosIconButton(
              boxConstraints: .tightFor(width: 38.0, height: 38.0),
              onPressed: onBackPressed,
              icon: MacosIcon(
                CupertinoIcons.back,
                size: 38.0,
                color: context.colors.secondaryLabel,
              ),
            ),
          ),
          MacosTooltip(
            useMousePosition: false,
            message: 'Home',
            child: MacosIconButton(
              boxConstraints: .tightFor(width: 38.0, height: 38.0),
              onPressed: onHomePressed,
              icon: MacosIcon(
                CupertinoIcons.home,
                size: 38.0,
                color: context.colors.secondaryLabel,
              ),
            ),
          ),
          MacosTooltip(
            useMousePosition: false,
            message: 'Übersicht',
            child: MacosIconButton(
              boxConstraints: .tightFor(width: 38.0, height: 38.0),
              onPressed: onAppLibraryPressed,
              icon: MacosIcon(
                CupertinoIcons.line_horizontal_3,
                size: 38.0,
                color: context.colors.secondaryLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
