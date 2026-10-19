import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/widgets.dart';

extension DeviceStatusColors on SynkUiColors {
  Color get deviceConnected => live;
  Color get deviceConnecting => accent;
  Color get deviceDisconnected => idle;
  Color get deviceUnauthorized => warn;
}
