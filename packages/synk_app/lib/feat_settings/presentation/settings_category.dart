import 'package:flutter/cupertino.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_capture_page.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_devices_page.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_general_page.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_tools_page.dart';

enum SettingsCategory {
  general(label: 'Allgemein', icon: CupertinoIcons.gear_alt),
  capture(label: 'Aufnahmen', icon: CupertinoIcons.camera),
  devices(label: 'Geräte', icon: CupertinoIcons.device_phone_portrait),
  tools(label: 'Tools', icon: CupertinoIcons.wrench);

  const SettingsCategory({required this.label, required this.icon});

  final String label;
  final IconData icon;

  Widget get page => switch (this) {
    general => const SettingsGeneralPage(),
    capture => const SettingsCapturePage(),
    devices => const SettingsDevicesPage(),
    tools => const SettingsToolsPage(),
  };
}
