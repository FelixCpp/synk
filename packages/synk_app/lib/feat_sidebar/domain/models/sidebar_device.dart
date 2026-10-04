import 'package:synk/feat_plugged_devices/domain/models/plugged_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sidebar_device.freezed.dart';

@freezed
sealed class SidebarDevice with _$SidebarDevice {
  const factory SidebarDevice({
    required PluggedDevice device,
    required bool isConnected,
  }) = _SidebarDevice;
}
