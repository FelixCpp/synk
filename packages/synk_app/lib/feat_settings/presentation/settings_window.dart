import 'dart:math' as math;

import 'package:synk/feat_settings/presentation/settings_category.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_capture_page.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_devices_page.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_general_page.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_nav.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_tools_page.dart';
import 'package:synk/feat_tool_validation/presentation/bloc/tool_validation_bloc.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _windowWidth = 780.0;
const _windowHeight = 560.0;
const _headerHeight = 48.0;

Future<void> showSettingsWindow(
  BuildContext context, {
  required String activeAdbPath,
  required String bundledAdbPath,
}) {
  // The dialog route lives above the providers of the calling context. The
  // bloc is handed over rather than its state, so re-running the tool check
  // from inside the window keeps the window in sync.
  final toolValidation = BlocProvider.of<ToolValidationBloc>(context);

  return showSynkUiDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => BlocProvider.value(
      value: toolValidation,
      child: SettingsWindow(
        activeAdbPath: activeAdbPath,
        bundledAdbPath: bundledAdbPath,
      ),
    ),
  );
}

class const SettingsWindow({
  super.key,
  required final String activeAdbPath,
  required final String bundledAdbPath,
}) extends StatefulWidget {
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
              // The mock is sized for a roomy main window; shrink rather than
              // overflow when the user has made the window small.
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
                            Expanded(
                              child: _Body(
                                category: _category,
                                activeAdbPath: widget.activeAdbPath,
                                bundledAdbPath: widget.bundledAdbPath,
                              ),
                            ),
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
              Text(
                'esc',
                style: theme.typography.mono.copyWith(
                  color: colors.textSecondary,
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

/// Every page stays alive so switching categories keeps scroll position.
class const _Body({
  required final SettingsCategory category,
  required final String activeAdbPath,
  required final String bundledAdbPath,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.synkUi.colors.surface,
      child: IndexedStack(
        index: category.index,
        sizing: StackFit.expand,
        children: [
          const SettingsGeneralPage(),
          const SettingsCapturePage(),
          const SettingsDevicesPage(),
          SettingsToolsPage(
            activeAdbPath: activeAdbPath,
            bundledAdbPath: bundledAdbPath,
          ),
        ],
      ),
    );
  }
}
