import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:synk/feat_device_pairing/domain/models/device_pairing_exception.dart';
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

  test('pairs with what was typed, trimmed', () async {
    submit(hostPort: '  192.168.1.23:41234 ', code: ' 123456 ');
    await pumpEventQueue();

    expect(pairing.attempts, [('192.168.1.23:41234', '123456')]);
    expect(bloc.state, const DevicePairingState.paired());
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
    final inFlight = Completer<void>();
    pairing.onPair = (_, _) => inFlight.future;

    submit();
    await pumpEventQueue();

    expect(bloc.state, const DevicePairingState.pairing());

    inFlight.complete();
    await pumpEventQueue();

    expect(bloc.state, const DevicePairingState.paired());
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
    final inFlight = Completer<void>();
    pairing.onPair = (_, _) => inFlight.future;

    submit();
    await pumpEventQueue();
    submit();
    await pumpEventQueue();

    expect(pairing.attempts, hasLength(1));

    inFlight.complete();
    await pumpEventQueue();
  });
}

class _FakePairing implements DevicePairingRepository {
  final attempts = <(String, String)>[];
  Future<void> Function(String hostPort, String code)? onPair;

  @override
  Future<void> pair(String hostPort, String code) {
    attempts.add((hostPort, code));
    return onPair?.call(hostPort, code) ?? Future.value();
  }
}
