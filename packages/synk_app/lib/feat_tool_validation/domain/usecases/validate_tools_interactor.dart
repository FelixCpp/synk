import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';
import 'package:synk/feat_tool_validation/domain/repositories/tool_validation_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const ValidateToolsInteractor(final ToolValidationRepository repository)
    implements ResultInteractor<List<ToolIssue>> {
  @override
  FutureOr<List<ToolIssue>> getOrThrow(Unit input) {
    return repository.validateTools();
  }
}
