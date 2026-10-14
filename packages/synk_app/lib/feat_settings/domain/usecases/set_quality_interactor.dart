import 'dart:async';

import 'package:synk/feat_settings/domain/models/mirror_quality.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const SetQualityInteractor(final SettingsRepository repository)
    implements ParameterizedInteractor<MirrorQuality> {
  @override
  FutureOr<void> getOrThrow(MirrorQuality input) {
    return repository.setQuality(input);
  }
}
