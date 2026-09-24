import 'package:device_viewer/conversions/adb_device_dto.dart';
import 'package:device_viewer/feat_devices/adb/data/datasources/adb_devices_datasource.dart';
import 'package:device_viewer/feat_devices/adb/domain/models/adb_device.dart';
import 'package:device_viewer/feat_devices/adb/domain/repositories/adb_devices_repository.dart';

class const AdbDevicesRepositoryImpl(
  final AdbDevicesDatasource datasource,
) implements AdbDevicesRepository {
  @override
  Stream<List<AdbDevice>> observeAdbDevices() {
    // yield [
    //   for (int i = 0; i < 2; ++i) ...[
    //     const AdbDevice(
    //       identity: AdbDeviceIdentity(
    //         serialNumber: AdbSerialNumber("R58M123456A"),
    //         product: AndroidProduct("b0q"),
    //         model: AndroidModel("SM_S918B"),
    //         device: AndroidDevice("b0q"),
    //       ),
    //       state: .connected,
    //       transport: AdbTransport(
    //         type: .unknown,
    //         id: AdbTransportId(1),
    //       ),
    //     ),
    //     const AdbDevice(
    //       identity: AdbDeviceIdentity(
    //         serialNumber: AdbSerialNumber("emulator-5554"),
    //         product: AndroidProduct("sdk_gphone64_arm64"),
    //         model: AndroidModel("sdk_gphone64_arm64"),
    //         device: AndroidDevice("emu64a"),
    //       ),
    //       state: .connected,
    //       transport: AdbTransport(
    //         type: .emulator,
    //         id: AdbTransportId(2),
    //       ),
    //     ),
    //     const AdbDevice(
    //       identity: AdbDeviceIdentity(
    //         serialNumber: AdbSerialNumber("192.168.1.42:5555"),
    //         product: AndroidProduct("cheetah"),
    //         model: AndroidModel("Pixel_7_Pro"),
    //         device: AndroidDevice("cheetah"),
    //       ),
    //       state: .connected,
    //       transport: AdbTransport(
    //         type: .tcp,
    //         id: AdbTransportId(3),
    //       ),
    //     ),
    //   ],
    // ];

    return datasource.observeAdbDevices().map((dtos) {
      return dtos.map((dto) => dto.toDomain()).toList();
    });
  }
}
