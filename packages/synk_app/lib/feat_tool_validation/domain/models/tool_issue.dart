enum ExternalTool {
  adb,
  devicectl,
  coreDevice,
}

enum ToolProblem {
  notFound,
  notRunnable,
  unsupportedMac,
}

class const ToolIssue({
  required final ExternalTool tool,
  required final ToolProblem problem,

  /// Raw, untranslated diagnostic output of the failed probe, if any.
  final String? detail,
});
