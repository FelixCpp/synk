import 'package:bench_ui/bench_ui.dart';
import 'package:device_viewer/design/theme/device_viewer_colors.dart';
import 'package:device_viewer/design/theme/device_viewer_typography.dart';
import 'package:flutter/widgets.dart';

extension ThemeGetters on BuildContext {
  BenchThemeData get benchTheme => BenchTheme.of(this);
  DeviceViewerColors get colors => DeviceViewerColors.of(this);
  DeviceViewerTypography get typo => DeviceViewerTypography.of(this);
}
