import 'package:synk/feat_device_platform/application/device_session.dart';
import 'package:synk/feat_device_platform/domain/models/device_input.dart';
import 'package:synk/feat_device_platform/domain/models/device_screen_size.dart';
import 'package:synk/feat_device_platform/domain/models/plugged_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_connection.freezed.dart';

@freezed
sealed class DeviceConnection with _$DeviceConnection {
  const DeviceConnection._();

  const factory DeviceConnection({
    required PluggedDevice device,
    required DeviceSession session,
    required DeviceScreenSize screenSize,
  }) = _DeviceConnection;

  NativeTextureId get textureId => session.textureId;

  bool get supportsInteraction => session.interaction != null;
  InteractionUnavailableReason? get interactionUnavailableReason =>
      session.interactionUnavailableReason;
  bool get supportsFileTransfer => session.fileTransfer != null;
  bool get supportsAudio => session.audio != null;

  Set<DeviceNavigation> get navigations {
    return session.interaction?.supportedNavigations ?? const {};
  }
}
