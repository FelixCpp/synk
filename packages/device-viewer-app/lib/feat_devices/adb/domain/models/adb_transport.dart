import 'package:freezed_annotation/freezed_annotation.dart';

part 'adb_transport.freezed.dart';

enum AdbTransportType {
  usb,
  tcp,
  emulator,
  unknown,
}

extension type const AdbTransportId(int value) implements int {
  static AdbTransportId? tryParse(String value) {
    if (int.tryParse(value) case int value) {
      return AdbTransportId(value);
    }

    return null;
  }
}

@freezed
sealed class AdbTransport with _$AdbTransport {
  const factory AdbTransport({
    required AdbTransportType type,
    required AdbTransportId? id,
  }) = _AdbTransport;
}
