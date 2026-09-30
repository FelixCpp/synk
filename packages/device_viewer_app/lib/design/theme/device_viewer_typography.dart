import 'package:bench_ui/bench_ui.dart';
import 'package:flutter/widgets.dart';

@immutable
class const DeviceViewerTypography._({
  required final TextStyle title3,
  required final TextStyle headline,
  required final TextStyle body,
  required final TextStyle caption1,
  required final TextStyle caption2,
}) {
  factory DeviceViewerTypography.of(BuildContext context) {
    final type = BenchTheme.of(context).type;

    return DeviceViewerTypography._(
      title3: type.title,
      headline: type.label,
      body: type.body,
      caption1: type.secondary,
      caption2: type.secondary.copyWith(fontSize: 11.0),
    );
  }
}
