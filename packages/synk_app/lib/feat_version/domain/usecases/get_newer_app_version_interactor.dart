import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:synk/feat_version/domain/models/newer_app_version.dart';
import 'package:synk/feat_version/domain/repositories/app_version_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const GetNewerAppVersionInteractor(
  final AppVersionRepository repository,
) implements ResultInteractor<NewerAppVersion> {
  @override
  FutureOr<NewerAppVersion> getOrThrow(Unit input) {
    return repository.getNewerAppVersion();
  }
}
