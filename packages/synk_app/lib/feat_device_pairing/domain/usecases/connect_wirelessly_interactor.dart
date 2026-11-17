import 'dart:async';

import 'package:synk/feat_device_pairing/domain/repositories/device_pairing_repository.dart';
import 'package:use_in_case/use_in_case.dart';

class const ConnectWirelesslyInteractor(
  final DevicePairingRepository repository,
) implements ParameterizedInteractor<String> {
  @override
  FutureOr<void> execute(String hostPort) {
    return repository.connect(hostPort);
  }
}
