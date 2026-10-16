import 'package:file_selector/file_selector.dart';
import 'package:synk/feat_settings/domain/models/settings.dart';
import 'package:synk/feat_settings/presentation/bloc/settings_bloc.dart';
import 'package:synk/feat_settings/presentation/widgets/settings_layout.dart';
import 'package:synk/feat_tool_validation/domain/models/adb_paths.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';
import 'package:synk/feat_tool_validation/presentation/bloc/tool_validation_bloc.dart';
import 'package:synk_ui/synk_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const SettingsToolsPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adbPaths = RepositoryProvider.of<AdbPaths>(context);

    return BlocBuilder<ToolValidationBloc, ToolValidationState>(
      builder: (context, validation) {
        final issues = validation.map(
          loading: (_) => null,
          toolsUnavailable: (state) => state.issues,
          toolsAvailable: (state) => state.warnings,
        );

        return BlocBuilder<SettingsBloc, Settings>(
          builder: (context, settings) {
            final customAdbPath = settings.customAdbPath;
            final bloc = context.read<SettingsBloc>();

            return SettingsPage(
              title: 'Tools',
              children: [
                SettingsSection(
                  title: 'Befehlszeilen-Tools',
                  children: [
                    _ToolRow(
                      name: 'adb',
                      issue: _issueFor(issues, ExternalTool.adb),
                      checking: issues == null,
                      availableMessage: customAdbPath ?? 'In Synk enthalten',
                      consequence: 'Android-Geräte nicht verfügbar',
                      needsRestart:
                          (customAdbPath ?? adbPaths.bundled) !=
                          adbPaths.active,
                      actions: [
                        if (customAdbPath != null)
                          SynkUiButton(
                            label: 'Standard',
                            variant: SynkUiButtonVariant.secondary,
                            onPressed: () => bloc.add(
                              .onSave(settings.copyWith(customAdbPath: null)),
                            ),
                          ),
                        SynkUiButton(
                          label: 'Eigenen Pfad …',
                          variant: SynkUiButtonVariant.secondary,
                          onPressed: () => _pickAdbPath(bloc, settings),
                        ),
                      ],
                    ),
                    _ToolRow(
                      name: 'devicectl',
                      issue: _issueFor(issues, ExternalTool.devicectl),
                      checking: issues == null,
                      availableMessage: 'Teil der Xcode-Befehlszeilen-Tools',
                      consequence: 'iOS-Geräte nicht verfügbar',
                      needsRestart: false,
                      actions: [
                        SynkUiButton(
                          label: 'Erneut prüfen',
                          variant: SynkUiButtonVariant.secondary,
                          onPressed: issues == null
                              ? null
                              : () => context.read<ToolValidationBloc>().add(
                                  const .onValidate(),
                                ),
                        ),
                      ],
                    ),
                    _ToolRow(
                      name: 'CoreDevice',
                      issue: _issueFor(issues, ExternalTool.coreDevice),
                      checking: issues == null,
                      availableMessage: 'Teil von Xcode',
                      consequence: 'iOS nur ansehen, ohne Touch und Ton',
                      needsRestart: false,
                      actions: const [],
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _pickAdbPath(SettingsBloc bloc, Settings settings) async {
    final file = await openFile(confirmButtonText: 'Auswählen');
    if (file == null) {
      return;
    }

    bloc.add(.onSave(settings.copyWith(customAdbPath: file.path)));
  }
}

ToolIssue? _issueFor(List<ToolIssue>? issues, ExternalTool tool) {
  if (issues == null) {
    return null;
  }

  for (final issue in issues) {
    if (issue.tool == tool) return issue;
  }

  return null;
}

class const _ToolRow({
  required final String name,
  required final ToolIssue? issue,
  required final bool checking,
  required final String availableMessage,
  required final String consequence,
  required final bool needsRestart,
  required final List<Widget> actions,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;
    final colors = theme.colors;
    final issue = this.issue;

    final (statusColor, message) = switch ((checking, issue)) {
      (true, _) => (colors.idle, 'Wird geprüft …'),
      (false, null) => (colors.live, availableMessage),
      (false, final issue?) => (
        colors.warn,
        '${_problemLabel(issue)} – $consequence',
      ),
    };

    return SettingsRow(
      spacing: SynkUiSpace.s12,
      leading: SynkUiStatusDot(color: statusColor),
      label: SettingsRowLabel(
        title: name,
        badge: needsRestart
            ? SynkUiTag(label: 'Neustart nötig', color: colors.warn)
            : null,
        subtitle: message,
        subtitleStyle: theme.typography.mono.copyWith(
          color: colors.textSecondary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: SynkUiSpace.s8,
        children: actions,
      ),
    );
  }

  String _problemLabel(ToolIssue issue) => switch (issue.problem) {
    ToolProblem.notFound => 'Nicht gefunden',
    ToolProblem.notRunnable => 'Nicht ausführbar',
    ToolProblem.unsupportedMac => 'Mac nicht unterstützt',
  };
}
