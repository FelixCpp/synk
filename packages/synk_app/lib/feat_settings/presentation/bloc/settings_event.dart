part of 'settings_bloc.dart';

@freezed
sealed class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.onSetup() = _OnSetup;
  const factory SettingsEvent.onSetThemeMode(ThemeMode themeMode) =
      _OnSetThemeMode;
}
