import 'dart:async';

import 'package:app_logger/app_logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:synk/feat_device_pairing/domain/models/pairable_device.dart';
import 'package:synk/feat_device_pairing/domain/models/pairing_outcome.dart';
import 'package:synk/feat_device_pairing/domain/repositories/device_pairing_repository.dart';
import 'package:synk/feat_device_pairing/domain/usecases/connect_wirelessly_interactor.dart';
import 'package:synk/feat_device_pairing/domain/usecases/pair_device_interactor.dart';
import 'package:synk/feat_notifications/domain/models/user_message.dart';
import 'package:use_in_case/use_in_case.dart';

part 'device_pairing_bloc.freezed.dart';
part 'device_pairing_event.dart';
part 'device_pairing_state.dart';

class DevicePairingBloc(final DevicePairingRepository repository)
    extends Bloc<DevicePairingEvent, DevicePairingState> {
  final pairDevice = PairDeviceInteractor(repository);
  final connectWirelessly = ConnectWirelesslyInteractor(repository);

  this : super(const DevicePairingState()) {
    on<_OnStarted>((event, emit) {
      return emit.forEach(
        repository.observePairableDevices(),
        onData: (devices) => state.copyWith(pairableDevices: devices),
        onError: (error, stackTrace) {
          appLogger.w(
            'Looking for pairable devices failed',
            error: error,
            stackTrace: stackTrace,
          );
          return state;
        },
      );
    }, transformer: droppable());
    on<_OnSubmitted>(_onSubmitted, transformer: droppable());
    on<_OnConnectPortSubmitted>(
      _onConnectPortSubmitted,
      transformer: droppable(),
    );
  }

  Future<void> _onSubmitted(
    _OnSubmitted event,
    Emitter<DevicePairingState> emit,
  ) async {
    final hostPort = event.hostPort.trim();
    final pairingCode = event.pairingCode.trim();

    if (hostPort.isEmpty || pairingCode.isEmpty) {
      _emitStep(
        emit,
        const DevicePairingStep.editing(
          error: 'Bitte IP-Adresse, Port und Code angeben.',
        ),
      );
      return;
    }

    _emitStep(emit, const DevicePairingStep.pairing());

    final PairingOutcome outcome;
    try {
      outcome = await pairDevice.logger().getOrThrow((
        hostPort: hostPort,
        pairingCode: pairingCode,
      ));
    } on Object catch (error, stackTrace) {
      appLogger.e('Pairing failed', error: error, stackTrace: stackTrace);
      _emitStep(
        emit,
        DevicePairingStep.editing(
          error: userMessageFor(error, 'Die Kopplung ist fehlgeschlagen.'),
        ),
      );
      return;
    }

    final host = _hostOf(hostPort);
    switch (outcome) {
      case PairingConnected():
        _emitStep(emit, const DevicePairingStep.connected());
      case PairingConnectPortResolved(:final port):
        await _connect(host, port, emit);
      case PairingConnectPortUnknown():
        appLogger.w('Paired with $host, but its connect port did not resolve');
        _emitStep(emit, DevicePairingStep.connectPortNeeded(host: host));
    }
  }

  Future<void> _onConnectPortSubmitted(
    _OnConnectPortSubmitted event,
    Emitter<DevicePairingState> emit,
  ) async {
    final current = state.step;
    if (current is! DevicePairingConnectPortNeeded) {
      return;
    }

    final port = int.tryParse(event.port.trim());
    if (port == null || port < 1 || port > 65535) {
      _emitStep(
        emit,
        DevicePairingStep.connectPortNeeded(
          host: current.host,
          error: 'Bitte einen gültigen Port angeben.',
        ),
      );
      return;
    }

    await _connect(current.host, port, emit);
  }

  Future<void> _connect(
    String host,
    int port,
    Emitter<DevicePairingState> emit,
  ) async {
    _emitStep(emit, DevicePairingStep.connecting(host: host));

    try {
      await connectWirelessly.logger().getOrThrow('$host:$port');
      _emitStep(emit, const DevicePairingStep.connected());
    } on Object catch (error, stackTrace) {
      appLogger.e('Connecting failed', error: error, stackTrace: stackTrace);
      _emitStep(
        emit,
        DevicePairingStep.connectPortNeeded(
          host: host,
          error: userMessageFor(error, 'Die Verbindung ist fehlgeschlagen.'),
        ),
      );
    }
  }

  void _emitStep(Emitter<DevicePairingState> emit, DevicePairingStep step) {
    emit(state.copyWith(step: step));
  }
}

String _hostOf(String hostPort) {
  final separator = hostPort.lastIndexOf(':');
  return separator == -1 ? hostPort : hostPort.substring(0, separator);
}
