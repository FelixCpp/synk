import 'package:freezed_annotation/freezed_annotation.dart';

part 'adb_device_identity.freezed.dart';

extension type const AdbSerialNumber(String value) implements String {}

extension type const AndroidProduct(String value) implements String {}

extension type const AndroidModel(String value) implements String {}

extension type const AndroidDevice(String value) implements String {}

@freezed
sealed class AdbDeviceIdentity with _$AdbDeviceIdentity {
  const factory AdbDeviceIdentity({
    required AdbSerialNumber serialNumber,
    required AndroidProduct? product,
    required AndroidModel? model,
    required AndroidDevice? device,
  }) = _AdbDeviceIdentity;
}
