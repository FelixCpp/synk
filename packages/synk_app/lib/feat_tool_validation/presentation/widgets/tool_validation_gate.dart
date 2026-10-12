import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synk/feat_tool_validation/data/repositories/tool_validation_repository_impl.dart';
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
    return RepositoryProvider<ToolValidationRepository>(
      create: (context) => ToolValidationRepositoryImpl(
        adbPath: adbPath,
        checkXcode: Platform.isMacOS,
      ),
      lazy: false,
      child: BlocProvider<ToolValidationBloc>(
        create: (context) => ToolValidationBloc(
          RepositoryProvider.of(context),
          RepositoryProvider.of(context),
        ),
        child: BlocBuilder<ToolValidationBloc, ToolValidationState>(
          builder: (context, state) {
            return state.map(
              loading: (_) => const Center(child: SynkUiSpinner()),
              toolsUnavailable: (state) => ToolIssuesScreen(
                issues: state.issues,
                onRetry: () {
                  BlocProvider.of<ToolValidationBloc>(context)
                      .add(const .onValidate());
                },
              ),
              toolsAvailable: (state) => builder(context, state.warnings),
            );
          },
        ),
      ),
    );
  }
}
