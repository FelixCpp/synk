abstract interface class ClipboardDeviceAgent {
  Future<void> setClipboard(String content);
  Future<String> getClipboard();
}
