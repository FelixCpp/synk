import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:synk/feat_device_frame/application/file_picker.dart';
import 'package:synk/feat_device_frame/domain/models/file_transfer_outcome.dart';
import 'package:synk/feat_device_frame/domain/usecases/send_files_interactor.dart';
import 'package:use_in_case/use_in_case.dart';

class const SendPickedApkInteractor({
  required final FilePicker filePicker,
  required final SendFilesInteractor sendFiles,
}) implements ResultInteractor<FileTransferOutcome?> {
  @override
  FutureOr<FileTransferOutcome?> getOrThrow(Unit input) {
    return sendFirstPicked(filePicker.pickApk, sendFiles);
  }
}

Future<FileTransferOutcome?> sendFirstPicked(
  Future<String?> Function() pick,
  SendFilesInteractor sendFiles,
) async {
  final filepath = await pick();
  if (filepath == null) {
    return null;
  }

  final outcomes = await sendFiles.getOrThrow([filepath]);
  return outcomes.isEmpty ? null : outcomes.first;
}
