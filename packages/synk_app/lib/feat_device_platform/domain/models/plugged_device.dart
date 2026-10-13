extension type const DeviceId(String value) implements String {}

abstract interface class PluggedDevice {
  DeviceId get id;
  String get modelName;
  bool get isAuthorized;
}
