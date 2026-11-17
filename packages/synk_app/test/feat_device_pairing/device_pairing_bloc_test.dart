import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_pairing/domain/models/device_pairing_exception.dart';
import 'package:synk/feat_device_pairing/domain/models/pairing_outcome.dart';
import 'package:synk/feat_device_pairing/domain/models/wireless_connect_exception.dart';
import 'package:synk/feat_device_pairing/domain/repositories/device_pairing_repository.dart';
import 'package:synk/feat_device_pairing/presentation/bloc/device_pairing_bloc.dart';

void main() {
  late _FakePairing pairing;
  late DevicePairingBloc bloc;

  setUp(() {
    pairing = _FakePairing();
    bloc = DevicePairingBloc(pairing);
    addTearDown(bloc.close);
  });

  void submit({
    String hostPort = '192.168.1.23:41234',
    String code = '123456',
  }) {
    bloc.add(
      DevicePairingEvent.onSubmitted(hostPort: hostPort, pairingCode: code),
    );
  }

  void submitPort(String port) {
    bloc.add(DevicePairingEvent.onConnectPortSubmitted(port: port));
  }

  test('pairs with what was typed, trimmed', () async {
    submit(hostPort: '  192.168.1.23:41234 ', code: ' 123456 ');
    await pumpEventQueue();

    expect(pairing.attempts, [('192.168.1.23:41234', '123456')]);
  });

  test(
    'connects on the port the device advertises, not the pairing port',
    () async {
      pairing.onPair = (_, _) async =>
          const PairingOutcome.connectPortResolved(37099);

      submit();
      await pumpEventQueue();

      expect(pairing.connections, ['192.168.1.23:37099']);
      expect(bloc.state, const DevicePairingState.connected());
    },
  );

  test('asks for the connect port when it did not resolve', () async {
    pairing.onPair = (_, _) async => const PairingOutcome.connectPortUnknown();

    submit();
    await pumpEventQueue();

    expect(pairing.connections, isEmpty);
    expect(
      bloc.state,
      const DevicePairingState.connectPortNeeded(host: '192.168.1.23'),
    );

    submitPort(' 37099 ');
    await pumpEventQueue();

    expect(pairing.connections, ['192.168.1.23:37099']);
    expect(bloc.state, const DevicePairingState.connected());
  });

  test('rejects a port that is not one, without calling adb', () async {
    pairing.onPair = (_, _) async => const PairingOutcome.connectPortUnknown();
    submit();
    await pumpEventQueue();

    submitPort('70000');
    await pumpEventQueue();

    expect(pairing.connections, isEmpty);
    expect(
      bloc.state,
      const DevicePairingState.connectPortNeeded(
        host: '192.168.1.23',
        error: 'Bitte einen gültigen Port angeben.',
      ),
    );
  });

  test('stays paired and asks for the port when connecting fails', () async {
    pairing.onPair = (_, _) async =>
        const PairingOutcome.connectPortResolved(37099);
    pairing.onConnect = (_) =>
        throw const WirelessConnectException(detail: 'Connection refused');

    submit();
    await pumpEventQueue();

    expect(bloc.state, isA<DevicePairingConnectPortNeeded>());
    final state = bloc.state as DevicePairingConnectPortNeeded;
    expect(state.host, '192.168.1.23');
    expect(state.error, contains('Connection refused'));
  });

  test('asks for the missing half instead of calling adb', () async {
    submit(code: '');
    await pumpEventQueue();

    expect(pairing.attempts, isEmpty);
    expect(
      bloc.state,
      const DevicePairingState.editing(
        error: 'Bitte IP-Adresse, Port und Code angeben.',
      ),
    );
  });

  test('reports while it is pairing, so the button can go quiet', () async {
    final inFlight = Completer<PairingOutcome>();
    pairing.onPair = (_, _) => inFlight.future;

    submit();
    await pumpEventQueue();

    expect(bloc.state, const DevicePairingState.pairing());

    inFlight.complete(const PairingOutcome.connected());
    await pumpEventQueue();

    expect(bloc.state, const DevicePairingState.connected());
  });

  test('shows what adb said when the code was wrong', () async {
    pairing.onPair = (_, _) =>
        throw const DevicePairingException(detail: 'wrong code');

    submit();
    await pumpEventQueue();

    expect(bloc.state, isA<DevicePairingEditing>());
    expect(
      (bloc.state as DevicePairingEditing).error,
      contains('wrong code'),
    );
  });

  test('keeps a developer-facing error out of the dialog', () async {
    pairing.onPair = (_, _) => throw StateError('socket closed');

    submit();
    await pumpEventQueue();

    expect(
      (bloc.state as DevicePairingEditing).error,
      'Die Kopplung ist fehlgeschlagen.',
    );
  });

  test('drops a second submit while one is in flight', () async {
    final inFlight = Completer<PairingOutcome>();
    pairing.onPair = (_, _) => inFlight.future;

    submit();
    await pumpEventQueue();
    submit();
    await pumpEventQueue();

    expect(pairing.attempts, hasLength(1));

    inFlight.complete(const PairingOutcome.connected());
    await pumpEventQueue();
  });
}

class _FakePairing implements DevicePairingRepository {
  final attempts = <(String, String)>[];
  final connections = <String>[];
  Future<PairingOutcome> Function(String hostPort, String code)? onPair;
  Future<void> Function(String hostPort)? onConnect;

  @override
  Future<PairingOutcome> pair(String hostPort, String code) {
    attempts.add((hostPort, code));
    return onPair?.call(hostPort, code) ??
        Future.value(const PairingOutcome.connected());
  }

  @override
  Future<void> connect(String hostPort) {
    connections.add(hostPort);
    return onConnect?.call(hostPort) ?? Future.value();
  }
}
