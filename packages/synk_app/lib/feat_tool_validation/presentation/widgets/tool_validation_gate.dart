import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';
import 'package:synk/feat_tool_validation/domain/repositories/tool_validation_repository.dart';
import 'package:synk/feat_tool_validation/presentation/bloc/tool_validation_bloc.dart';
import 'package:synk/feat_tool_validation/presentation/widgets/tool_issues_screen.dart';
import 'package:synk_ui/synk_ui.dart';

typedef ToolValidationGateBuilder = Widget Function(
  BuildContext context,
  List<ToolIssue> warnings,
);

class const ToolValidationGate({
  super.key,
  required final String adbPath,
  required final ToolValidationGateBuilder builder,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ToolValidationBloc>(
      create: (context) => ToolValidationBloc(
        RepositoryProvider.of<ToolValidationRepository>(context),
        RepositoryProvider.of<NotificationService>(context),
      ),
      child: _Gate(builder: builder),
    );
  }
}

class const _Gate({required final ToolValidationGateBuilder builder})
    extends StatefulWidget {
  @override
  State<_Gate> createState() => _GateState();
}

class _GateState extends State<_Gate> {
  /// The last finished check, so a re-run can keep the app on screen.
  List<ToolIssue>? _lastWarnings;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToolValidationBloc, ToolValidationState>(
      listener: (context, state) {
        state.map(
          loading: (_) {},
          toolsUnavailable: (_) {},
          toolsAvailable: (state) => _lastWarnings = state.warnings,
        );
      },
      builder: (context, state) {
        return state.map(
          loading: (_) {
            final warnings = _lastWarnings;

            // Re-checking the tools from the settings window must not unmount
            // the device stack — that would drop every running mirror.
            if (warnings != null) {
              return widget.builder(context, warnings);
            }

            return const Center(child: SynkUiSpinner());
          },
          toolsUnavailable: (state) => ToolIssuesScreen(
            issues: state.issues,
            onRetry: () {
              BlocProvider.of<ToolValidationBloc>(context)
                  .add(const .onValidate());
            },
          ),
          toolsAvailable: (state) => widget.builder(context, state.warnings),
        );
      },
    );
  }
}
