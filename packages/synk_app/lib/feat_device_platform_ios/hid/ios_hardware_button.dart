typedef IosHardwareButton = ({int usagePage, int usageCode});

const _consumerPage = 0x0c;
const _consumerSleepWake = 0x30;

const IosHardwareButton iosPowerButton = (
  usagePage: _consumerPage,
  usageCode: _consumerSleepWake,
);
