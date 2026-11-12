part of 'app_version_bloc.dart';

@freezed
sealed class AppVersionState with _$AppVersionState {
  const factory AppVersionState({
    required AppVersion currentAppVersion,
    required NewerAppVersion? newerAppVersion,
    required bool isUpdating,
    required double? downloadProgress,
    required bool isReadyToRestart,
  }) = _AppVersionState;

  factory AppVersionState.initial(AppVersion currentAppVersion) {
    return .new(
      currentAppVersion: currentAppVersion,
      newerAppVersion: null,
      isUpdating: false,
      downloadProgress: null,
      isReadyToRestart: false,
    );
  }
}
