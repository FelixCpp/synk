import 'package:device_viewer/feat_device_agent/domain/models/device_screen_size.dart';
import 'package:device_viewer/feat_device_canvas/data/datasources/screen_mirror_texture_datasource.dart';
import 'package:device_viewer/feat_plugged_devices/adb/domain/models/android_device.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'canvas_device.freezed.dart';

extension type const NativeTextureId(int value) implements int {}

class const NativeTexture._({
  required final NativeTextureId id,
  required final ScreenMirrorTextureDatasource datasource,
}) {
  static Future<NativeTexture> create(
    ScreenMirrorTextureDatasource datasource,
  ) async {
    final textureId = await datasource.createTexture();
    return ._(id: textureId, datasource: datasource);
  }

  Future<void> dispose() async {
    await datasource.destroyTexture(id);
  }

  Future<void> upload(Uint8List chunk) async {
    await datasource.sendChunk(id, chunk);
  }
}

@freezed
sealed class CanvasDevice with _$CanvasDevice {
  const factory CanvasDevice.android({
    required AndroidDevice device,
    required bool isConnected,
    required NativeTextureId textureId,

    /// Shape the mirror has to be drawn in. Devices differ widely here
    /// (9:19.5, 9:20, tablets), so the frame follows this instead of
    /// assuming a ratio.
    required DeviceScreenSize screenSize,
  }) = _AndroidCanvasDevice;

  /// Shown the moment the user asks to connect, before the agent connection
  /// (and its mirror texture) actually exists - establishing it takes a
  /// couple of seconds, and the canvas would otherwise give no feedback
  /// during that time.
  const factory CanvasDevice.connecting({required AndroidDevice device}) =
      _ConnectingCanvasDevice;
}
