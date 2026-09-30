part of 'theme_mode_bloc.dart';

@freezed
sealed class ThemeModeEvent with _$ThemeModeEvent {
  const factory ThemeModeEvent.onSetup() = _OnSetup;
  const factory ThemeModeEvent.onToggleThemeMode() = _OnToggleThemeMode;
}
