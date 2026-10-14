import 'package:flutter/widgets.dart';
import 'package:synk/app_shortcuts.dart';

class const SettingsShortcut({
  super.key,
  required final VoidCallback onInvoke,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {AppShortcuts.openSettings: onInvoke},
      child: FocusScope(autofocus: true, child: child),
    );
  }
}
