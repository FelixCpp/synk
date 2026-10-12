import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';

/// Which external tools are usable, derived from the problems found.
class const ToolAvailability({
  required final bool isAdbAvailable,
  required final bool isDevicectlAvailable,
}) {
  factory ToolAvailability.fromIssues(List<ToolIssue> issues) {
    bool isAvailable(ExternalTool tool) {
      return !issues.any((issue) => issue.tool == tool);
    }

    return ToolAvailability(
      isAdbAvailable: isAvailable(.adb),
      isDevicectlAvailable: isAvailable(.devicectl),
    );
  }
}
