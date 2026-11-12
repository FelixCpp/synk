import 'dart:async';

import 'package:synk/feat_version/domain/models/update_outcome.dart';
import 'package:synk/feat_version/domain/repositories/app_version_repository.dart';
import 'package:use_in_case/use_in_case.dart';

final class UpdateToNewestAppVersionInteractor(
  final AppVersionRepository repository,
) extends ResultProgressInteractor<UpdateOutcome, double> {
  @override
  FutureOr<UpdateOutcome> execute(NoInput input) {
    return repository.updateToNewestRelease(onProgress: emitProgress);
  }
}
