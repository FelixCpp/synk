import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_notifications/application/notification_service.dart';
import 'package:synk/feat_tool_validation/domain/models/tool_issue.dart';
import 'package:synk/feat_tool_validation/domain/repositories/tool_validation_repository.dart';
import 'package:synk/feat_tool_validation/domain/usecases/validate_tools_interactor.dart';
import 'package:use_in_case/use_in_case.dart';

part 'tool_validation_bloc.freezed.dart';
part 'tool_validation_event.dart';
part 'tool_validation_state.dart';

class ToolValidationBloc(
  final ToolValidationRepository repository,
  final NotificationService notifications,
) extends Bloc<ToolValidationEvent, ToolValidationState> {
  final validateTools = ValidateToolsInteractor(repository);

  this : super(const .loading()) {
    on<_OnValidate>(_onValidate, transformer: droppable());

    add(const .onValidate());
  }

  FutureOr<void> _onValidate(
    _OnValidate event,
    Emitter<ToolValidationState> emit,
  ) {
    return validateTools
        .logger()
        .after((issues) {
          // Degraded features are warnings; only without any usable tool is the
          // app pointless.
          final failedTools = {for (final issue in issues) issue.tool};
          final isUnavailable =
              failedTools.length == ExternalTool.values.length;
          if (isUnavailable) {
            return emit(.toolsUnavailable(issues: issues));
          }

          emit(.toolsAvailable(warnings: issues));
        })
        .intercept((e) {
          notifications.notify(.new(message: 'Failed to validate tools: $e'));
          emit(const .toolsUnavailable(issues: []));
        })
        .run(unit);
  }
}
