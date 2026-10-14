import 'dart:async';

import 'package:synk/feat_settings/domain/models/mirror_frame_rate.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const SetFrameRateInteractor(final SettingsRepository repository)
    implements ParameterizedInteractor<MirrorFrameRate> {
  @override
  FutureOr<void> getOrThrow(MirrorFrameRate input) {
    return repository.setFrameRate(input);
  }
}
