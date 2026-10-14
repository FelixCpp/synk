import 'dart:async';

import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const SetScreenCaptureSavePathInteractor(final SettingsRepository repository)
    implements ParameterizedInteractor<String> {
  @override
  FutureOr<void> getOrThrow(String input) {
    return repository.setScreenCaptureSavePath(input);
  }
}
