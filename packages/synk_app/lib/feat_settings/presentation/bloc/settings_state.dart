part of 'settings_bloc.dart';

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState({
    required ThemeMode themeMode,
    required String? screenCaptureSavePath,
  }) = _SettingsState;

  factory SettingsState.initial(ThemeMode mode) {
    return .new(
      themeMode: mode,
      screenCaptureSavePath: null,
    );
  }
}
