part of 'device_frame_bloc.dart';

@freezed
sealed class DeviceFrameState with _$DeviceFrameState {
  const factory DeviceFrameState({
    required bool isTransferringFiles,
    required bool isRecording,
    required bool isAudioMuted,
    required double audioVolume,
  }) = _DeviceFrameState;

  factory DeviceFrameState.initial({
    required bool isAudioMuted,
    required double audioVolume,
  }) {
    return .new(
      isTransferringFiles: false,
      isRecording: false,
      isAudioMuted: isAudioMuted,
      audioVolume: audioVolume,
    );
  }
}
