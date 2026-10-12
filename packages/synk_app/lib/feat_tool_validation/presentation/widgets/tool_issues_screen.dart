import 'package:flutter/cupertino.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';
import 'package:synk/feat_tool_validation/presentation/widgets/tool_issue_message.dart';
import 'package:synk_ui/synk_ui.dart';

class const ToolIssuesScreen({
  super.key,
  required final List<ToolIssue> issues,
  required final VoidCallback onRetry,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.synkUi;

    return ColoredBox(
      color: theme.colors.canvas,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Synk kann nicht starten'),
              const SizedBox(height: 16),
              if (issues.isEmpty)
                const Text(
                  'Die benötigten Werkzeuge konnten nicht geprüft werden.',
                  textAlign: TextAlign.center,
                ),
              for (final issue in issues) ...[
                Text(issue.message, textAlign: TextAlign.center),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 16),
              SynkUiButton(label: 'Erneut prüfen', onPressed: onRetry),
            ],
          ),
        ),
      ),
    );
  }
}
