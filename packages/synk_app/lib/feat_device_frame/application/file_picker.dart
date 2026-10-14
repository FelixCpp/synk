import 'package:file_selector/file_selector.dart';

abstract interface class FilePicker {
  Future<String?> pickApk();
  Future<String?> pickAnyFile();
}

class const SystemFilePicker() implements FilePicker {
  static const _apks = XTypeGroup(label: 'APKs', extensions: ['apk']);

  @override
  Future<String?> pickApk() async {
    final file = await openFile(acceptedTypeGroups: const [_apks]);
    return file?.path;
  }

  @override
  Future<String?> pickAnyFile() async {
    final file = await openFile();
    return file?.path;
  }
}
