import 'dart:async';

import 'package:synk/feat_device_pairing/domain/models/pairing_outcome.dart';
import 'package:synk/feat_device_pairing/domain/repositories/device_pairing_repository.dart';
import 'package:use_in_case/use_in_case.dart';

typedef PairDeviceInput = ({
  String hostPort,
  String pairingCode,
});

class const PairDeviceInteractor(final DevicePairingRepository repository)
    implements ParameterizedResultInteractor<PairDeviceInput, PairingOutcome> {
  @override
  FutureOr<PairingOutcome> execute(PairDeviceInput input) {
    return repository.pair(input.hostPort, input.pairingCode);
  }
}
