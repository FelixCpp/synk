import 'package:synk/feat_device_platform/application/agents/audio_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/clipboard_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/file_transfer_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/interaction_device_agent.dart';
import 'package:synk/feat_device_platform/application/agents/screen_capture_device_agent.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/domain/models/native_texture_id.dart';

abstract interface class DeviceAgent {
  NativeTextureId get textureId;
  DeviceScreenSize get screenSize;
  Stream<DeviceScreenSize> get screenSizeChanges;

  AudioDeviceAgent? get audio;
  ClipboardDeviceAgent? get clipboard;
  ScreenCaptureDeviceAgent? get screenCapture;
  InteractionDeviceAgent? get interaction;
  FileTransferDeviceAgent? get fileTransfer;

  Future<void> dispose();
}
