import 'dart:async';

import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const SetShowSidebarOnStartInteractor(final SettingsRepository repository)
    implements ParameterizedInteractor<bool> {
  @override
  FutureOr<void> getOrThrow(bool input) {
    return repository.setShowSidebarOnStart(input);
  }
}
