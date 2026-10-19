import 'dart:async';

import 'package:path/path.dart' as path;
import 'package:synk/feat_device_frame/domain/models/file_transfer_outcome.dart';
import 'package:synk/feat_device_frame/domain/repositories/device_frame_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const SendFilesInteractor(final DeviceFrameRepository repository)
    implements
        ParameterizedResultInteractor<List<String>, List<FileTransferOutcome>> {
  @override
  FutureOr<List<FileTransferOutcome>> getOrThrow(List<String> input) async {
    final outcomes = <FileTransferOutcome>[];

    for (final filepath in input) {
      outcomes.add(await _send(filepath));
    }

    return outcomes;
  }

  Future<FileTransferOutcome> _send(String filepath) async {
    final filename = path.basename(filepath);

    if (_isApk(filepath)) {
      await repository.installApk(filepath);
      return (action: FileTransferAction.installed, filename: filename);
    }

    await repository.pushFile(filepath);
    return (action: FileTransferAction.pushed, filename: filename);
  }

  bool _isApk(String filepath) {
    return path.extension(filepath).toLowerCase() == '.apk';
  }
}
