import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sidebar_device.freezed.dart';

@freezed
sealed class SidebarDevice with _$SidebarDevice {
  const factory SidebarDevice({
    required AndroidDevice device,
    required bool isConnected,
  }) = _SidebarDevice;
}
