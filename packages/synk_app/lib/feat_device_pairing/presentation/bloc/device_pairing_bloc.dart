import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_device_pairing/domain/repositories/device_pairing_repository.dart';
import 'package:synk/feat_device_pairing/domain/usecases/connect_wirelessly_interactor.dart';
import 'package:synk/feat_notifications/domain/models/user_message.dart';

part 'device_pairing_bloc.freezed.dart';
part 'device_pairing_event.dart';
part 'device_pairing_state.dart';

class DevicePairingBloc(final DevicePairingRepository repository)
    extends Bloc<DevicePairingEvent, DevicePairingState> {
  final connectWirelessly = ConnectWirelesslyInteractor(repository);

  this : super(const DevicePairingState.editing()) {
    on<_OnSubmitted>(_onSubmitted, transformer: droppable());
  }

  Future<void> _onSubmitted(
    _OnSubmitted event,
    Emitter<DevicePairingState> emit,
  ) async {
    final hostPort = event.hostPort.trim();
    final pairingCode = event.pairingCode.trim();

    if (hostPort.isEmpty || pairingCode.isEmpty) {
      emit(
        const DevicePairingState.editing(
          error: 'Bitte IP-Adresse, Port und Code angeben.',
        ),
      );
      return;
    }

    emit(const DevicePairingState.pairing());

    try {
      await connectWirelessly.logger().getOrThrow((
        hostPort: hostPort,
        pairingCode: pairingCode,
      ));
      emit(const DevicePairingState.paired());
    } on Object catch (error, stackTrace) {
      appLogger.e('Pairing failed', error: error, stackTrace: stackTrace);
      emit(
        DevicePairingState.editing(
          error: userMessageFor(error, 'Die Kopplung ist fehlgeschlagen.'),
        ),
      );
    }
  }
}
