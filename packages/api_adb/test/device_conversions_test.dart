import 'package:api_adb/adb/devices/adb_connection_type_dto.dart';
import 'package:api_adb/adb/devices/adb_device_state_dto.dart';
import 'package:api_adb/adb/devices/device_conversions.dart';
import 'package:api_adb/adb/proto/generated/lib/adb/proto/devices.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';

void main() {
  test('maps required fields and leaves optional fields null when unset', () {
    final device = Device(
      serial: 'emulator-5554',
      state: ConnectionState.DEVICE,
      connectionType: ConnectionType.USB,
    );

    final dto = device.toDto();

    expect(dto.serialNumber, 'emulator-5554');
    expect(dto.state, AdbDeviceStateDto.device);
    expect(dto.connectionType, AdbConnectionTypeDto.usb);
    expect(dto.busAddress, isNull);
    expect(dto.product, isNull);
    expect(dto.model, isNull);
    expect(dto.device, isNull);
    expect(dto.negotiatedSpeed, isNull);
    expect(dto.maxSpeed, isNull);
    expect(dto.transportId, isNull);
  });

  test('maps optional fields through when present on the proto', () {
    final device = Device(
      serial: 'R58N30ABCDE',
      state: ConnectionState.DEVICE,
      connectionType: ConnectionType.SOCKET,
      busAddress: '1-1',
      product: 'panther',
      model: 'Pixel_7',
      device: 'panther',
      negotiatedSpeed: Int64(480),
      maxSpeed: Int64(480),
      transportId: Int64(3),
    );

    final dto = device.toDto();

    expect(dto.busAddress, '1-1');
    expect(dto.product, 'panther');
    expect(dto.model, 'Pixel_7');
    expect(dto.device, 'panther');
    expect(dto.negotiatedSpeed, 480);
    expect(dto.maxSpeed, 480);
    expect(dto.transportId, 3);
  });
}
