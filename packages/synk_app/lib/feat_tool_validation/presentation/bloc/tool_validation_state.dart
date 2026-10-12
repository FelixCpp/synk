part of 'tool_validation_bloc.dart';

@freezed
sealed class ToolValidationState with _$ToolValidationState {
  const factory ToolValidationState.loading() = _ToolValidationLoading;
  const factory ToolValidationState.toolsUnavailable({
    required List<ToolIssue> issues,
  }) = _ToolsUnavailable;
  const factory ToolValidationState.toolsAvailable({
    required List<ToolIssue> warnings,
  }) = _ToolsAvailable;
}
