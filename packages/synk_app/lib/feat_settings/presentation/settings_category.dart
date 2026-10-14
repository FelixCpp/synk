import 'package:flutter/cupertino.dart';

enum SettingsCategory {
  general(label: 'Allgemein', icon: CupertinoIcons.gear_alt),
  capture(label: 'Aufnahmen', icon: CupertinoIcons.camera),
  devices(label: 'Geräte', icon: CupertinoIcons.device_phone_portrait),
  tools(label: 'Tools', icon: CupertinoIcons.wrench);

  const SettingsCategory({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
