import 'package:file_selector/file_selector.dart';
import 'package:synk/feat_settings/domain/models/settings.dart';
import 'package:synk/feat_settings/domain/models/theme_mode.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';
import 'package:synk/feat_settings/presentation/settings_window.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _rowGutter = 16.0;

class const SettingsPopover({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SynkUiPopover(
      triggerBuilder: (context, controller) {
        return SynkUiTooltip(
          message: 'Einstellungen',
          child: SynkUiIconButton(
            icon: CupertinoIcons.gear_alt,
            onPressed: () {
              controller.isOpen ? controller.close() : controller.open();
            },
          ),
        );
      },
      builder: (context, controller) => _Content(controller: controller),
    );
  }
}

class const _Content({
  required final MenuController controller,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;

    return BlocBuilder<SettingsBloc, Settings>(
      builder: (context, settings) {
        final bloc = context.read<SettingsBloc>();

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                _rowGutter,
                14.0,
                _rowGutter,
                SynkUiSpace.s6,
              ),
              child: Text(
                'Einstellungen',
                style: theme.typography.label.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                _rowGutter,
                SynkUiSpace.s4,
                _rowGutter,
                SynkUiSpace.s8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Row(
                    label: 'Design',
                    trailing: SynkUiSegmentedControl<ThemeMode>(
                      dense: true,
                      value: settings.themeMode,
                      segments: const [
                        SynkUiSegment(value: ThemeMode.light, label: 'Hell'),
                        SynkUiSegment(value: ThemeMode.dark, label: 'Dunkel'),
                        SynkUiSegment(value: ThemeMode.system, label: 'System'),
                      ],
                      onChanged: (themeMode) => bloc.add(
                        .onSave(settings.copyWith(themeMode: themeMode)),
                      ),
                    ),
                  ),
                  const _Divider(),
                  _SavePath(settings: settings),
                  const _Divider(),
                  _Row(
                    label: 'Vorschau nach Aufnahme',
                    trailing: SynkUiToggle(
                      value: settings.showCapturePreview,
                      onChanged: (value) => bloc.add(
                        .onSave(settings.copyWith(showCapturePreview: value)),
                      ),
                    ),
                  ),
                  _Row(
                    label: 'Zwischenablage synchronisieren',
                    trailing: SynkUiToggle(
                      value: settings.syncClipboard,
                      onChanged: (value) => bloc.add(
                        .onSave(settings.copyWith(syncClipboard: value)),
                      ),
                    ),
                  ),
                  _Row(
                    label: 'Beim Verbinden stummschalten',
                    trailing: SynkUiToggle(
                      value: settings.muteOnConnect,
                      onChanged: (value) => bloc.add(
                        .onSave(settings.copyWith(muteOnConnect: value)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _Footer(controller: controller),
          ],
        );
      },
    );
  }
}

class const _Row({
  required final String label,
  required final Widget trailing,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SynkUiSpace.s8),
      child: Row(
        spacing: SynkUiSpace.s12,
        children: [
          Expanded(
            child: Text(
              label,
              style: context.synkUi.typography.label,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class const _Divider() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SynkUiSpace.s4),
      child: SizedBox(
        height: SynkUiSize.hairline,
        child: ColoredBox(color: context.synkUi.colors.line),
      ),
    );
  }
}

class const _SavePath({required final Settings settings})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SynkUiSpace.s8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: SynkUiSpace.s6,
        children: [
          Text('Speicherort für Aufnahmen', style: theme.typography.label),
          Row(
            spacing: SynkUiSpace.s8,
            children: [
              Expanded(
                child: Container(
                  height: SynkUiSize.control,
                  padding: const EdgeInsets.symmetric(
                    horizontal: SynkUiSpace.s8,
                  ),
                  decoration: BoxDecoration(
                    color: colors.inset,
                    borderRadius: BorderRadius.circular(SynkUiRadius.control),
                  ),
                  child: Row(
                    spacing: SynkUiSpace.s6,
                    children: [
                      Icon(
                        CupertinoIcons.folder,
                        size: SynkUiSize.icon,
                        color: colors.textSecondary,
                      ),
                      Expanded(
                        child: Text(
                          settings.screenCaptureSavePath,
                          style: theme.typography.mono.copyWith(
                            color: colors.text,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SynkUiButton(
                label: 'Ändern …',
                variant: SynkUiButtonVariant.secondary,
                onPressed: () => _pickSavePath(context, settings),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickSavePath(BuildContext context, Settings settings) async {
    final bloc = context.read<SettingsBloc>();

    final directory = await getDirectoryPath(
      initialDirectory: settings.screenCaptureSavePath,
      confirmButtonText: 'Auswählen',
    );

    if (directory == null) {
      return;
    }

    bloc.add(.onSave(settings.copyWith(screenCaptureSavePath: directory)));
  }
}

class const _Footer({
  required final MenuController controller,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.panel,
        border: Border(
          top: BorderSide(color: colors.line, width: SynkUiSize.hairline),
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(SynkUiRadius.card - SynkUiSize.hairline),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _rowGutter,
          vertical: 10.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: SynkUiInteractive(
                cursor: SystemMouseCursors.click,
                onPressed: () {
                  controller.close();
                  showSettingsWindow(context);
                },
                builder: (context, states) {
                  return Text(
                    'Alle Einstellungen …',
                    style: theme.typography.secondary.copyWith(
                      fontWeight: FontWeight.w500,
                      color: states.contains(WidgetState.hovered)
                          ? colors.text
                          : colors.accent,
                    ),
                  );
                },
              ),
            ),
            Text(
              '⌘ ,',
              style: theme.typography.mono.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
