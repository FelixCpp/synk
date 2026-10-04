part of 'theme_mode_bloc.dart';

@freezed
sealed class ThemeModeState with _$ThemeModeState {
  const factory ThemeModeState({
    required ThemeMode themeMode,
  }) = _ThemeModeState;
}
