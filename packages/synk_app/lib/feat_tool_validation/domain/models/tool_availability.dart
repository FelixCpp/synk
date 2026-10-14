import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';

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

  bool isAvailable(ExternalTool tool) {
    return switch (tool) {
      .adb => isAdbAvailable,
      .devicectl => isDevicectlAvailable,
    };
  }
}
