import 'dart:async';

import 'package:synk/feat_settings/domain/models/settings.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const SaveSettingsInteractor(final SettingsRepository repository)
    implements ParameterizedInteractor<Settings> {
  @override
  FutureOr<void> getOrThrow(Settings input) {
    return repository.save(input);
  }
}
