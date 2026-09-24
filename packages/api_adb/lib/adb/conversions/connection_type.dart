import 'package:api_adb/adb/dtos/adb_connection_type_dto.dart';
import 'package:api_adb/adb/proto/generated/lib/adb/proto/devices.pbenum.dart';

extension ConnectionTypeToDto on ConnectionType {
  AdbConnectionTypeDto toDto() {
    return switch (this) {
      ConnectionType.UNKNOWN => .unknown,
      ConnectionType.USB => .usb,
      ConnectionType.SOCKET => .socket,
      _ => throw Exception('Invalid Type'),
    };
  }
}
