import 'dart:async';

import 'package:synk/feat_version/domain/repositories/app_version_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const RestartAppInteractor(final AppVersionRepository repository)
    implements Interactor {
  @override
  FutureOr<void> execute(NoInput input) {
    return repository.restart();
  }
}
