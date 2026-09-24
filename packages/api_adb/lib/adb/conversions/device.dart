import 'package:api_adb/adb/conversions/connection_type.dart';
import 'package:api_adb/adb/conversions/device_state.dart';
import 'package:api_adb/adb/dtos/adb_device_dto.dart';
import 'package:api_adb/adb/proto/generated/lib/adb/proto/devices.pb.dart';

extension DeviceToDto on Device {
  AdbDeviceDto toDto() {
    return AdbDeviceDto(
      serialNumber: serial,
      state: state.toDto(),
      connectionType: connectionType.toDto(),
      busAddress: hasBusAddress() ? busAddress : null,
      product: hasProduct() ? product : null,
      model: hasModel() ? model : null,
      device: hasDevice() ? device : null,
      negotiatedSpeed: hasNegotiatedSpeed() ? negotiatedSpeed.toInt() : null,
      maxSpeed: hasMaxSpeed() ? maxSpeed.toInt() : null,
      transportId: hasTransportId() ? transportId.toInt() : null,
    );
  }
}
