import 'package:bench_ui/bench_ui.dart';
import 'package:flutter/widgets.dart';

class const DeviceFrameSurface({
  super.key,
  required final bool hasFocus,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BenchCard(
      radius: BenchRadius.frame,
      clip: true,
      focused: hasFocus,
      child: child,
    );
  }
}
