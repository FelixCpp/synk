import 'package:api_adb/adb/parsers/adb_devices_parser.dart';
import 'package:api_adb/api_adb.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group(AdbDevicesParser, () {
    test("should parse multiple lines", () {
      final processOutput = '''
List of devices attached
R58M123456A device product:b0q model:SM_S918B device:b0q transport_id:1
emulator-5554 device product:sdk_gphone64_arm64 model:sdk_gphone64_arm64 device:emu64a transport_id:2
192.168.1.42:5555 device product:cheetah model:Pixel_7_Pro device:cheetah transport_id:3
''';

      final devices = AdbDevicesParser.parse(processOutput);
      expect(
        devices,
        orderedEquals(const [
          AdbDeviceDto(
            serialNumber: "R58M123456A",
            state: .device,
            product: "b0q",
            model: "SM_S918B",
            device: "b0q",
            transportId: "1",
          ),
          AdbDeviceDto(
            serialNumber: "emulator-5554",
            state: .device,
            product: "sdk_gphone64_arm64",
            model: "sdk_gphone64_arm64",
            device: "emu64a",
            transportId: "2",
          ),
          AdbDeviceDto(
            serialNumber: "192.168.1.42:5555",
            state: .device,
            product: "cheetah",
            model: "Pixel_7_Pro",
            device: "cheetah",
            transportId: "3",
          ),
        ]),
      );
    });
  });
}
