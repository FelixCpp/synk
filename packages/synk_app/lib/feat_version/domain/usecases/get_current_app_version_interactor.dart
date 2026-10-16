import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:synk/feat_version/domain/models/app_version.dart';
import 'package:synk/feat_version/domain/repositories/app_version_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const GetCurrentAppVersionInteractor(
  final AppVersionRepository repository,
) implements ResultInteractor<AppVersion> {
  @override
  FutureOr<AppVersion> getOrThrow(Unit input) {
    return repository.getCurrentAppVersion();
  }
}
