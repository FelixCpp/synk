import 'dart:async';

import 'package:synk_ui/synk_ui.dart';
import 'package:synk/feat_theme_mode/data/repositories/theme_mode_repository_impl.dart';
import 'package:synk/feat_theme_mode/domain/models/theme_mode.dart';
import 'package:synk/feat_theme_mode/domain/repositories/theme_mode_repository.dart';
import 'package:synk/feat_theme_mode/presentation/bloc/theme_mode_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const ThemeModeProvider({
  super.key,
  required final BlocWidgetBuilder<ThemeModeState> builder,
}) extends StatefulWidget {
  @override
  State<ThemeModeProvider> createState() => _ThemeModeProviderState();
}

class _ThemeModeProviderState extends State<ThemeModeProvider> {
  late final ThemeModeRepository repository;
  late final Future<ThemeMode> loadThemeMode;

  @override
  void initState() {
    super.initState();
    repository = ThemeModeRepositoryImpl();
    loadThemeMode = repository.getThemeMode();
  }

  @override
  void dispose() {
    unawaited(repository.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ThemeModeRepository>.value(
      value: repository,
      child: FutureBuilder<ThemeMode>(
        future: loadThemeMode,
        builder: (context, asyncSnapshot) {
          final themeMode = asyncSnapshot.data;
          if (!asyncSnapshot.hasData || themeMode == null) {
            return BenchTheme(
              data: BenchThemeData.dark,
              child: const Center(child: BenchSpinner()),
            );
          }

          return BlocProvider<ThemeModeBloc>(
            create: (context) => ThemeModeBloc(
              themeMode: themeMode,
              repository: repository,
              notifications: RepositoryProvider.of(context),
            ),
            child: BlocBuilder<ThemeModeBloc, ThemeModeState>(
              builder: widget.builder,
            ),
          );
        },
      ),
    );
  }
}
