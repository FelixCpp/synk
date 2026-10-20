import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:synk/feat_settings/domain/settings_feature.dart';
import 'package:use_in_case/use_in_case.dart';

class const RevealScreenCaptureSavePathInteractor(
  final SettingsFeature feature,
) implements Interactor {
  @override
  FutureOr<void> getOrThrow(Unit input) {
    return feature.revealScreenCaptureSavePath();
  }
}
