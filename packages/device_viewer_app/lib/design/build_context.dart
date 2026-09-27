import 'package:device_viewer/design/theme/device_viewer_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

extension ThemeGetters on BuildContext {
  MacosThemeData get macosTheme => MacosTheme.of(this);
  DeviceViewerColors get colors => DeviceViewerColors.of(this);
  MacosTypography get typo => MacosTypography.of(this);
}
