import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:synk/feat_sidebar/domain/models/sidebar_device.dart';

/// What the sidebar can do: watch the plugged devices and act on one.
abstract interface class SidebarFeature {
  Stream<List<SidebarDevice>> observeDevices();
  Future<void> connect(PluggedDevice device);
  Future<void> disconnect(PluggedDevice device);
  Future<void> openCameraPrivacySettings();
}
