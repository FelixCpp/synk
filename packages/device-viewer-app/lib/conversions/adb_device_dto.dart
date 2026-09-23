import 'package:api_adb/adb/dtos/adb_device_dto.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/adb_device.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/adb_device_connection_state.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/adb_device_identity.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/adb_transport.dart';

extension AdbDeviceDtoToModel on AdbDeviceDto {
  AdbDevice toDomain() {
    return AdbDevice(
      identity: AdbDeviceIdentity(
        serialNumber: AdbSerialNumber(serialNumber),
        product: product?.asAndroidProduct(),
        model: model?.asAndroidModel(),
        device: device?.asAndroidDevice(),
      ),
      state: state.toConnectionState(),
      transport: AdbTransport(
        type: detectTransportType(serialNumber),
        id: transportId?.asAdbTransportId(),
      ),
    );
  }
}

extension on String {
  AndroidProduct asAndroidProduct() => AndroidProduct(this);
  AndroidModel asAndroidModel() => AndroidModel(this);
  AndroidDevice asAndroidDevice() => AndroidDevice(this);
  AdbTransportId? asAdbTransportId() => AdbTransportId.tryParse(this);
}

extension on AdbDeviceState {
  AdbDeviceConnectionState toConnectionState() {
    return switch (this) {
      .device => .connected,
      .offline => .offline,
      .unauthorized => .unauthorized,
      .recovery => .recovery,
      .sideload => .sideload,
      .authorizing => .authorizing,
      .disconnect => .disconnect,
    };
  }
}

AdbTransportType detectTransportType(String serial) {
  if (serial.startsWith('emulator-')) {
    return AdbTransportType.emulator;
  }

  if (RegExp(r'^.+:\d+$').hasMatch(serial)) {
    return AdbTransportType.tcp;
  }

  return AdbTransportType.unknown;
}
