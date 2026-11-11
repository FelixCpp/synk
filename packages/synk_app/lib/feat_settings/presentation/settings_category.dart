import 'package:flutter/cupertino.dart';
import 'package:synk/feat_settings/domain/models/settings_category.dart';

extension SettingsCategoryLook on SettingsCategory {
  String get label => switch (this) {
    .general => 'Allgemein',
    .capture => 'Aufnahmen',
    .devices => 'Geräte',
    .tools => 'Tools',
  };

  IconData get icon => switch (this) {
    .general => CupertinoIcons.gear_alt,
    .capture => CupertinoIcons.camera,
    .devices => CupertinoIcons.device_phone_portrait,
    .tools => CupertinoIcons.wrench,
  };
}
