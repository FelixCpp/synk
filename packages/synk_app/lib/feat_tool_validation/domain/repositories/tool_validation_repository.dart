import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';

abstract interface class ToolValidationRepository {
  Future<List<ToolIssue>> validateTools();
}
