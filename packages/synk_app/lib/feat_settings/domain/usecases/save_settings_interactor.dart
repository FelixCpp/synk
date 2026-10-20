import 'dart:async';

import 'package:synk/feat_settings/domain/models/settings.dart';
import 'package:synk/feat_settings/domain/settings_feature.dart';
import 'package:use_in_case/use_in_case.dart';

class const SaveSettingsInteractor(final SettingsFeature feature)
    implements ParameterizedInteractor<Settings> {
  @override
  FutureOr<void> getOrThrow(Settings input) {
    return feature.save(input);
  }
}
