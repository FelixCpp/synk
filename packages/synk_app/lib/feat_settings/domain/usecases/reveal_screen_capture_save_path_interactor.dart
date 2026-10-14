import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:synk/feat_screen_capture_preview/application/system_file_opener.dart';
import 'package:synk/feat_settings/domain/repositories/settings_repository.dart';
import 'package:use_in_case/use_in_case.dart';

/// Opens the folder captures are written to in the system's file browser.
class const RevealScreenCaptureSavePathInteractor(
  final SettingsRepository repository,
  final SystemFileOpener opener,
) implements Interactor {
  @override
  FutureOr<void> getOrThrow(Unit input) async {
    await opener.open(await repository.getScreenCaptureSavePath());
  }
}
