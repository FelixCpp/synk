import 'dart:async';

import 'package:synk/feat_sidebar/domain/sidebar_feature.dart';
import 'package:use_in_case/use_in_case.dart';

class const OpenCameraPrivacySettingsInteractor(final SidebarFeature feature)
    implements Interactor {
  @override
  FutureOr<void> execute(NoInput input) {
    return feature.openCameraPrivacySettings();
  }
}
