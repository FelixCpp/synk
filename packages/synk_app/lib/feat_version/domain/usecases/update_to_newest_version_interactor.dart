import 'dart:async';

import 'package:synk/feat_version/domain/repositories/app_version_repository.dart';
import 'package:use_in_case/use_in_case.dart';

final class UpdateToNewestAppVersionInteractor(
  final AppVersionRepository repository,
) extends ProgressInteractor<double> {
  @override
  FutureOr<void> execute(NoInput input) {
    return repository.updateToNewestRelease(onProgress: emitProgress);
  }
}
