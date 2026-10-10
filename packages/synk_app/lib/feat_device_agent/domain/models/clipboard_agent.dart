abstract interface class ClipboardAgent {
  Future<String> readDeviceClipboardContent();
  Future<void> setDeviceClipboardContent(String clipboard);
}
