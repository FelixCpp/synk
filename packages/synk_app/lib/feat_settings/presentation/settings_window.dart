import 'dart:math' as math;

import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';
import 'package:synk/feat_settings/presentation/settings_category.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_nav.dart';
import 'package:synk/feat_tool_validation/domain/models/adb_paths.dart';
import 'package:synk/feat_tool_validation/presentation/bloc/tool_validation_bloc.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _windowWidth = 780.0;
const _windowHeight = 560.0;
const _headerHeight = 48.0;

Future<void> showSettingsWindow(BuildContext context) {
  final toolValidation = BlocProvider.of<ToolValidationBloc>(context);
  final settings = BlocProvider.of<SettingsBloc>(context);
  final adbPaths = RepositoryProvider.of<AdbPaths>(context);

  return showSynkUiDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: toolValidation),
        BlocProvider.value(value: settings),
      ],
      child: RepositoryProvider.value(
        value: adbPaths,
        child: const SettingsWindow(),
      ),
    ),
  );
}

class const SettingsWindow({super.key}) extends StatefulWidget {
  @override
  State<SettingsWindow> createState() => _SettingsWindowState();
}

class _SettingsWindowState extends State<SettingsWindow> {
  var _category = SettingsCategory.general;

  void _close() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.escape): _close,
        },
        child: FocusScope(
          autofocus: true,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SynkUiCard(
                elevation: SynkUiElevation.modal,
                clip: true,
                child: SizedBox(
                  width: math.min(_windowWidth, constraints.maxWidth),
                  height: math.min(_windowHeight, constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Header(onClose: _close),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SettingsNav(
                              selected: _category,
                              onSelected: (category) {
                                setState(() => _category = category);
                              },
                            ),
                            Expanded(child: _Body(category: _category)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class const _Header({required final VoidCallback onClose})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.panel,
        border: Border(
          bottom: BorderSide(
            color: colors.line,
            width: SynkUiSize.hairline,
          ),
        ),
      ),
      child: SizedBox(
        height: _headerHeight,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: SynkUiSpace.s12,
          ),
          child: Row(
            spacing: SynkUiSpace.s8,
            children: [
              Expanded(
                child: Text(
                  'Einstellungen',
                  style: theme.typography.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SynkUiIconButton(
                icon: CupertinoIcons.xmark,
                onPressed: onClose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _Body({
  required final SettingsCategory category,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.synkUi.colors.surface,
      child: IndexedStack(
        index: category.index,
        sizing: StackFit.expand,
        children: [
          for (final category in SettingsCategory.values) category.page,
        ],
      ),
    );
  }
}
