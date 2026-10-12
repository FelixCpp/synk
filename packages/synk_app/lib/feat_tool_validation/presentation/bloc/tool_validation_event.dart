part of 'tool_validation_bloc.dart';

@freezed
sealed class ToolValidationEvent with _$ToolValidationEvent {
  const factory ToolValidationEvent.onValidate() = _OnValidate;
}
