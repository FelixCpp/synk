import 'package:synk/feat_device_agent/domain/models/interaction_agent.dart';

typedef IosHardwareButton = ({int usagePage, int usageCode});

const _consumerPage = 0x0c;
const _consumerSleepWake = 0x30;

IosHardwareButton? iosButtonForControlAction(DeviceControlAction action) {
  return switch (action) {
    .standby => (usagePage: _consumerPage, usageCode: _consumerSleepWake),
    .back || .home || .appSwitch => null,
  };
}
