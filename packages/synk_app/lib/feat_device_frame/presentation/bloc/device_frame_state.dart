part of 'device_frame_bloc.dart';

@freezed
sealed class DeviceFrameState with _$DeviceFrameState {
  const factory DeviceFrameState({
    required bool isProcessingDroppedFiles,
    required bool isRecording,
    required bool isAudioMuted,
  }) = _DeviceFrameState;

  factory DeviceFrameState.initial() {
    return const .new(
      isProcessingDroppedFiles: false,
      isRecording: false,
      isAudioMuted: true,
    );
  }
}
