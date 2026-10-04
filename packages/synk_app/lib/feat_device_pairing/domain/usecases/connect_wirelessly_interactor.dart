import 'dart:async';

import 'package:synk/feat_device_pairing/domain/repositories/device_pairing_repository.dart';
import 'package:use_in_case/use_in_case.dart';

typedef ConnectWirelesslyInput = ({
  String hostPort,
  String pairingCode,
});

class const ConnectWirelesslyInteractor(final DevicePairingRepository repositoy)
    implements ParameterizedInteractor<ConnectWirelesslyInput> {
  @override
  FutureOr<void> getOrThrow(ConnectWirelesslyInput input) {
    return repositoy.pair(input.hostPort, input.pairingCode);
  }
}
